///////////////////////////////////////////////////////////////////////////////////
// Университет       : Рязанский государственный радиотехнический университет имени В.Ф. Уткина
// Инженер           : ЧИНЬ НГОК ХИЕУ - аспирант кафедры РТС (РГРТУ)
// Mail              : ngochieu.radioscientist@mail.ru 
// Дата создания     : 13.02.2025
// Название модуля   : top_module 
// Название проекта  : FPGA - sequential architecture of the modified FFT algorithm
// Описание          : Главный модуль последовательной архитектуры модифицированного алгоритма БПФ на FPGA
///////////////////////////////////////////////////////////////////////////////////
// `define SIMULATION 

module top_module #(
    parameter    word_length_tw = 14,  // (6,7,8,...,16) Разрядность данных 
	                                    // коэффициентов вращения (sin/cos) 
                 stagger        = 20,  // (0,5,10,15,20,25) Степень вобуляции 
					                        // периода повторения импульсов в процентах 
                 N              = 256,// Количество выборок (размер БПФ)
			        bit_width      = 24   // Разрядность данных
) (    
    input         CLK,             // Входной тактовый сигнал
    input         RST_N,           // Сброс (активный низкий уровень)
    input         data_in,         // Входные данные UART
    input   [3:0] key,             // Входные кнопки управления
    output        tx_o,            // Выход UART (передача)
    output  [3:0] led,             // Светодиоды состояния
    output  [7:0] HEX0,            // Сегменты 7-сегментного индикатора
    output  [7:0] HEX1,
    output  [7:0] HEX2,
    output  [7:0] HEX3   		     
);

    // Локальный параметр: вычисление ширины адреса 
	 function integer clog2;
	    input integer value;
		 integer  j;
		 begin
		    clog2 = 0;
			 for (j = value; j > 1; j = j>>1)
			 clog2 = clog2 + 1;
		 end
	 endfunction
	 
	 parameter   SIZE = clog2(N);


    // Определение различных разрядностей для симуляции и реальной работы
    `ifdef SIMULATION
        localparam t_1_bit = 4'd9,        // Время передачи 1 бита (симуляция)
                   t_half_1_bit = 4'd4;   // Половина времени передачи 1 бита
    `else    
        localparam t_1_bit = 16'd5207,    // Время передачи 1 бита (реальная работа)
                   t_half_1_bit = 16'd2603; // Половина времени передачи 1 бита
    `endif

    // Объявление внутренних соединений для обработки данных
    wire signed [bit_width-1:0] Re_o, Im_o;  // Действительная и мнимая часть результата БПФ
    wire signed [bit_width-1:0] Re_i, Im_i;  // Действительная и мнимая часть входных данных БПФ
    wire [SIZE-1:0] invert_addr;             // Инвертированный адрес (для перестановки)
    wire load_data, finish_FFT;              // Флаги загрузки данных и завершения БПФ
    wire tx_done_o, en_tx;                   // Флаги передачи данных по UART
    wire clk = CLK, rst_n = RST_N;           // Тактовый сигнал и сигнал сброса
    wire start_flag, en_out;                 // Флаг начала БПФ и разрешение вывода
    wire [7:0] data_i_uart;                  // Данные для передачи через UART
    wire en_proc_data, done_o;               // Флаги обработки данных
    wire [7:0] signal;                       // Обрабатываемый сигнал
    wire en_invert;                          // Разрешение инвертирования адресов

    //------------------------------------------------------------------
    // Модуль приема данных по UART
    uart_rx #(.t_1_bit(t_1_bit), .t_half_1_bit(t_half_1_bit)) UART_RX (
        .clk(clk),
        .rst_n(rst_n),
        .rx_i(data_in),
        .data_o(signal),
        .rx_done_o(en_invert)
    );

    //------------------------------------------------------------------
    // Модуль инверсии адресов для перестановки входных данных
    INVERT_ADDR  #(
        .bit_width(bit_width),
        .N(N),
        .SIZE(SIZE),
        .t_1_bit(t_1_bit),
        .t_half_1_bit(t_half_1_bit)
    ) INVERT_ADDR (
        .clk(clk),
        .rst_n(rst_n),
        .en_invert(en_invert),
        .signal(signal),
        .Re_o(Re_i),
        .Im_o(Im_i),
        .invert_addr(invert_addr),
        .en_o(load_data),
        .start_flag(start_flag)
    );

    //------------------------------------------------------------------
    // Основной модуль БПФ
    generate
    if (stagger == 0) begin
        CLASS_FFT  #(
            .word_length_tw(word_length_tw),
            .t_1_bit(t_1_bit),
            .bit_width(bit_width),
            .N(N),
            .SIZE(SIZE)
        ) CLASS_FFT (
            .clk(clk),
            .rst_n(rst_n),
            .start_flag(start_flag),
            .load_data(load_data),
            .Re_i(Re_i),
            .Im_i(Im_i),
            .invert_addr(invert_addr),
            .en_out(en_out),
            .Re_o(Re_o),
            .Im_o(Im_o),
            .en_o(en_proc_data),
            .finish_FFT(finish_FFT),
            .done_o(done_o)
        );
    end else begin
        MODIFY_FFT  #(
            .word_length_tw(word_length_tw),
            .stagger(stagger),
            .t_1_bit(t_1_bit),
            .bit_width(bit_width),
            .N(N),
            .SIZE(SIZE)
        ) MODIFY_FFT (
            .clk(clk),
            .rst_n(rst_n),
            .start_flag(start_flag),
            .load_data(load_data),
            .Re_i(Re_i),
            .Im_i(Im_i),
            .invert_addr(invert_addr),
            .en_out(en_out),
            .Re_o(Re_o),
            .Im_o(Im_o),
            .en_o(en_proc_data),
            .finish_FFT(finish_FFT),
            .done_o(done_o)
        );
    end
    endgenerate

    //------------------------------------------------------------------
    // Модуль обработки выходных данных БПФ перед отправкой через UART
    PROCESS_O_DATA #(
        .t_1_bit(t_1_bit),
        .bit_width(bit_width)
    ) PROCESS_O_DATA (
        .clk(clk),
        .rst_n(rst_n),
        .en_wr(en_proc_data),
        .en_rd(tx_done_o),
        .data_re_i(Re_o),
        .data_im_i(Im_o),
        .data_out(data_i_uart),
        .en_o(en_tx),
        .done_o(en_out)
    );

    //------------------------------------------------------------------
    // Модуль передачи данных по UART
    uart_tx #(
        .t_1_bit(t_1_bit)
    ) UART_TX (
        .clk(clk),
        .rst_n(rst_n),
        .en_i(en_tx),
        .data_i(data_i_uart),
        .tx_o(tx_o),
        .tx_done_o(tx_done_o)
    );

    //------------------------------------------------------------------
    // Модуль управления 7-сегментным индикатором
    seg7_data2  #(
        .bit_width(bit_width),
        .N(N),
        .SIZE(SIZE)
    ) SEG7_DATA2 (
        .clk(clk),
        .rst_n(rst_n),
        .key(key),
        .en_FFT(start_flag),
        .finish_FFT(finish_FFT),
        .done_all(done_o),
        .Re_in(Re_o),
        .Im_in(Im_o),
        .en_comp(en_proc_data),
		  .HEX0(HEX0),
		  .HEX1(HEX1),
		  .HEX2(HEX2),
		  .HEX3(HEX3),
        .led(led)
    );

endmodule


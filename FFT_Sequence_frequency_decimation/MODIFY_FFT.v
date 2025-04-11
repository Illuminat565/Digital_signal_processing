module MODIFY_FFT
  #(parameter word_length_tw = 14,               // Разрядность данных коэффициентов вращения (значения sin/cos)
    stagger = 15,                                // Процент рассогласования 
    t_1_bit = 5207,                              // Временной интервал передачи одного бита для UART
    bit_width = 24, N = 16, SIZE = 4)            // Параметры FFT: Разрядность данных, Количество выборок (размер БПФ) и ширина адреса
(
    input                            clk,        // Тактовый сигнал
    input                            rst_n,      // Сброс (активный низкий уровень)
//    input                            start_flag, // Флаг начала выполнения FFT
//    input                            load_data,  // Флаг загрузки данных
    input                            en_invert,         
    input    signed  [bit_width-1:0] Re_i,       // Действительная часть входных данных FFT
    input    signed  [bit_width-1:0] Im_i,       // Мнимая часть входных данных FFT
//    input            [SIZE-1     :0] invert_addr,// Адрес для перестановки данных в памяти
    input                            en_out,     // Разрешение вывода данных

    output   signed  [bit_width-1:0] Re_o,       // Действительная часть выходных данных после FFT
    output   signed  [bit_width-1:0] Im_o,       // Мнимая часть выходных данных после FFT
    output                           en_o,       // Флаг разрешения вывода данных
    output                           finish_FFT, // Сигнал завершения работы FFT
    output                           done_o      // Флаг окончания обработки данных
);

    // Внутренние сигналы для хранения промежуточных данных FFT
    wire  signed [bit_width-1:0] Re_temp1, Im_temp1, Re_temp2, Im_temp2;
    wire  signed [bit_width-1:0] Re_temp3, Im_temp3, Re_temp4, Im_temp4;
    wire  signed [bit_width-1:0] Re_temp5, Im_temp5, Re_temp6, Im_temp6;

    // Управляющие сигналы для управления потоками данных и этапами обработки
    wire en_o_temp, en_wr, en_rd, en_add, en_modify;
    wire out_valid, en_radix, en_mul,en_modify_tw;
    wire [SIZE-1:0]  invert_adr;

    // Адресные указатели для чтения и записи в память
    wire [10:0] rd_ptr_angle;   // Указатель угла для коэффициентов вращения
    wire [SIZE-1:0] wr_ptr, rd_ptr; // Указатели чтения и записи
    wire [10:0] rd_ptr_angle_final; 

    // Выходные сигналы демультиплексора для разделения потоков данных
    wire signed [bit_width-1:0] Re_demul, Im_demul;

    // Данные коэффициентов вращения (значения sin и cos)
    wire signed [word_length_tw-1:0] sin_data_2, cos_data_2;
    wire signed [word_length_tw-1:0] sin_data_radix, cos_data_radix;
    wire signed [word_length_tw-1:0] sin_data_radix2, cos_data_radix2;
    wire signed [word_length_tw-1:0] sin_data_radix3, cos_data_radix3;
    wire signed [word_length_tw-1:0] sin_data, cos_data;
    wire signed [word_length_tw-1:0] sin_data_3, cos_data_3;

    //----------------------------------------------------------------------  
    // Модуль управления: управляет сигналами управления FFT, такими как запуск,  
    // разрешение вывода, управление указателями чтения/записи.  
    MODIFY_CONTROL #( .t_1_bit(t_1_bit), .bit_width(bit_width), .N(N), .SIZE(SIZE)) control_unit (
        .clk(clk),
        .rst_n(rst_n),
        .en_invert(en_invert),
    //    .flag_start_FFT(start_flag),\
        .invert_adr(invert_adr),
        .en_out(en_out),
        .en_modify(en_modify),
        .en_modify_tw(en_modify_tw),
        .wr_ptr(wr_ptr),
        .rd_ptr(rd_ptr),
        .rd_ptr_angle(rd_ptr_angle),
        .rd_ptr_angle_final(rd_ptr_angle_final),
        .en_rd(en_rd),
        .finish_FFT(finish_FFT),
        .load_data(load_data),
        .out_valid(out_valid),
        .done_o(done_o)
    );

    //----------------------------------------------------------------------  
    // Сдвиговый регистр: обеспечивает сдвиг указателя чтения в указатель записи  
    // в процессе выполнения FFT.  
 /*   shift_register #(.width(SIZE+1), .depth(5)) shift_reg_inst (
        .clk(clk),
        .rst_n(rst_n),
        .in_data(rd_ptr),
        .out_data(wr_ptr)
    );*/

    //----------------------------------------------------------------------  
    // Модуль памяти RAM: используется для хранения входных данных FFT,  
    // промежуточных вычислений и управления операциями чтения/записи.  
    RAM #( .bit_width(bit_width), .N(N), .SIZE(SIZE)) ram_data_store (
        .clk(clk),
        .rst_n(rst_n),
        .load_data(load_data),
        .invert_adr(invert_adr),
        .Re_i1(Re_i),
        .Im_i1(Im_i),
        .en_wr(en_wr),
        .Re_i2(Re_temp1),
        .Im_i2(Im_temp1),
        .out_valid(out_valid),
        .wr_ptr(wr_ptr),
        .rd_ptr(rd_ptr),
        .en_rd(en_rd),
        .Re_o(Re_o),
        .Im_o(Im_o),
        .en_radix(en_radix),
        .out_valid_data(en_o)
    );

    //----------------------------------------------------------------------  
    // Генератор коэффициентов вращения: формирует значения sin и cos  
    // для использования в вычислениях FFT на основе углового указателя.  

    TWIDLE_14_bit #( .SIZE(10),.word_length_tw(word_length_tw))
    TWIDLE_14_bit_inst (
    .clk(clk),
    .en_rd(en_rd),
    .rd_ptr_angle(rd_ptr_angle),

    .cos_data(cos_data),
    .sin_data(sin_data)
    );
    TWIDLE_14_bit_final_STAGE_1 #( .SIZE(10),.word_length_tw(word_length_tw))
    TWIDLE_14_bit_final_STAGE_1 (
    .clk(clk),
    .en_rd(en_rd),
    .rd_ptr_angle(rd_ptr_angle_final),

    .cos_data(cos_data_2),
    .sin_data(sin_data_2)
    );

    TWIDLE_14_bit_final_STAGE_2 #( .SIZE(10),.word_length_tw(word_length_tw))
    TWIDLE_14_bit_final_STAGE_2 (
    .clk(clk),
    .en_rd(en_rd),
    .rd_ptr_angle(rd_ptr_angle_final+512),

    .cos_data(cos_data_3),
    .sin_data(sin_data_3)
    );

    //----------------------------------------------------------------------  
    // Демультиплексор: разделяет входные данные на несколько потоков  
    // для параллельной обработки во время выполнения FFT.  
    demultiplexor #(.bit_width(bit_width), .word_length_tw(word_length_tw)) demux_inst (
        .clk(clk),
        .rst_n(rst_n),
        .Re_i(Re_o),
        .Im_i(Im_o),
 //       .cos_data(cos_data),
 //       .sin_data(sin_data),
        .in_valid(en_radix),
        .Re_o1(Re_temp2),
        .Im_o1(Im_temp2),
        .Re_o2(Re_temp4),
        .Im_o2(Im_temp4),
 //       .o_cos_data(cos_data_radix),
  //      .o_sin_data(sin_data_radix),
        .out_valid(en_add)
    );
    //---------------------------------------------------------------------
        shift_register #(.width(word_length_tw), .depth(1)) shift_reg_inst2 (
        .clk(clk),
        .rst_n(rst_n),
        .in_data(cos_data),
        .out_data(cos_data_radix)
    );

        shift_register #(.width(word_length_tw), .depth(1)) shift_reg_inst3 (
        .clk(clk),
        .rst_n(rst_n),
        .in_data(sin_data),
        .out_data(sin_data_radix)
    );
        shift_register #(.width(word_length_tw), .depth(1)) shift_reg_inst4 (
        .clk(clk),
        .rst_n(rst_n),
        .in_data(cos_data_2),
        .out_data(cos_data_radix2)
    );

        shift_register #(.width(word_length_tw), .depth(1)) shift_reg_inst5 (
        .clk(clk),
        .rst_n(rst_n),
        .in_data(sin_data_2),
        .out_data(sin_data_radix2)
    );        
    
        shift_register #(.width(word_length_tw), .depth(1)) shift_reg_inst6 (
        .clk(clk),
        .rst_n(rst_n),
        .in_data(cos_data_3),
        .out_data(cos_data_radix3)
    );

        shift_register #(.width(word_length_tw), .depth(1)) shift_reg_inst7 (
        .clk(clk),
        .rst_n(rst_n),
        .in_data(sin_data_3),
        .out_data(sin_data_radix3)
    );
    //----------------------------------------------------------------------  
    // Модификация FFT (Modified Radix-2):С допольнительным умножением 
    // FFT по алгоритмам Modified Radix-2 и Radix-2.  
    MODIFY_RADIX2 #( .bit_width(bit_width), .word_length_tw(word_length_tw)) modify_radix2_inst (
        .clk(clk),
        .rst_n(rst_n),
        .en_modify(0),
        .sin_data(sin_data_radix),
        .cos_data(cos_data_radix),
        .sin_data2(sin_data_radix2),
        .cos_data2(cos_data_radix2),
        .sin_data3(sin_data_radix3),
        .cos_data3(cos_data_radix3),
        .Re_i1(Re_temp2),
        .Im_i1(Im_temp2),
        .Re_i2(Re_temp4),
        .Im_i2(Im_temp4),
        .en(en_add),
        .Re_o1(Re_temp3),
        .Im_o1(Im_temp3),
        .Re_o2(Re_temp5),
        .Im_o2(Im_temp5),
        .out_valid(en_mul)
    );

    //----------------------------------------------------------------------  
    // Мультиплексор: выбирает корректный промежуточный результат  
    // для обратного поступления в RAM.  
    multiplexor #(.bit_width(bit_width)) mux_inst (
        .clk(clk),
        .rst_n(rst_n),
        .Re_i_1(Re_temp3),
        .Im_i_1(Im_temp3),
        .Re_i_2(Re_temp5),
        .Im_i_2(Im_temp5),
        .in_valid(en_mul),
        .Re_o(Re_temp1),
        .Im_o(Im_temp1),
        .out_valid(en_wr)
    );

endmodule

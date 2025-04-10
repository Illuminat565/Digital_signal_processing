module testbench;

    // Тактовый сигнал и сигнал сброса
    logic clk;
    logic aresetn;

    // Остальные сигналы
    logic  [3:0][1:0] sel;
    logic       [3:0] in;
    logic       [3:0] out;

    // Output access indicator
    bit         [3:0] vld;

    router DUT(
        .clk     ( clk     ),
        .aresetn ( aresetn ),
        .sel     ( sel     ),
        .in      ( in      ),
        .out     ( out     )
    );

    // TODO:
    // Найдите все ошибки в модуле ~router~

    // TODO:
    // Определите период тактового сигнала
    parameter CLK_PERIOD = 10;

    // TODO:
    // Cгенерируйте тактовый сигнал
    initial begin
        clk <= 0;
        forever begin
            #(CLK_PERIOD/2) clk <= ~clk;
        end
    end

    // TODO:
    // Cгенерируйте сигнал сброса
    initial begin
        aresetn <= 0;
        #(CLK_PERIOD);
        aresetn <= 1;
    end

    // TODO:
    // Сгенерируйте входные сигналы
    // Не забудьте про ожидание сигнала сброса!
    initial begin
        wait(!aresetn);
        sel <= '0;
        in  <= '0;
        wait(aresetn);
        for(int i = 0; i < 256; i = i + 1) begin
            @(posedge clk);
            sel <= i;
            for(int j = 0; j < 32; j = j + 1) begin
                in <= j;
                @(posedge clk);
            end
        end
        @(posedge clk);
        $stop();
    end

    // Пользуйтесь этой структурой
    typedef struct {
        logic  [3:0][1:0] sel;
        logic       [3:0] in;
        logic       [3:0] out;
    } packet;

    mailbox#(packet) mon2chk = new();

    // TODO:
    // Сохраняйте сигналы каждый положительный
    // фронт тактового сигнала

    initial begin
        packet pkt;
        wait(aresetn);
        forever begin
            @(posedge clk);
            // Пишите здесь.
            pkt.sel = sel;
            pkt.in  = in;
            pkt.out = out;
            mon2chk.put(pkt);
        end
    end

    // TODO:
    // Выполните проверку выходных сигналов
    initial begin
        packet pkt_prev, pkt_cur;
        wait(aresetn);
        mon2chk.get(pkt_prev);
        forever begin
            mon2chk.get(pkt_cur);

            // Пишите здесь
            for(int i = 0; i < 4; i = i + 1) begin
              for(int j = 0; j < 4; j = j + 1) begin
                if( pkt_prev.sel[j] == i ) begin
                  vld[i] = 1;
                  if( pkt_cur.out[i] !== pkt_prev.in[j] )
                      $error("Invalid routing at out[%0d]: \
                        Must be in[%0d] = %1b", i, j, pkt_prev.in[j]);
                  break;
                end
              end
            end
            foreach(vld[i]) begin
                if( !vld[i] && (out[i] !== 0) ) begin
                    $error("Invalid routing at out[%0d]: \
                        Must be default (0)", i);
                end
            end
            vld = '0;
            pkt_prev = pkt_cur;
        end
    end

endmodule


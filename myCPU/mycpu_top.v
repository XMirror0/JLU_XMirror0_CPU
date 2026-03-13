module ConflictDetecter(
    input wire need_r1,
    input wire need_r1_r2,

    input wire [4:0] waddr_Ex,
    input wire [4:0] waddr_Mem,
    input wire [4:0] waddr_WB,
    input wire [4:0] raddr1,
    input wire [4:0] raddr2,
    output reg [4:0] forward_source1,  //rf_rdata:0x01 alu_res_Ex:0x02 mem_rdata:0x04 alu_res_Mem:0x08 rf_wdata:0x10
    output reg [4:0] forward_source2,

    input wire valid_Ex,
    input wire valid_Mem,
    input wire valid_WB,
    input wire wen_Ex,
    input wire wen_Mem,
    input wire wen_WB,
    input wire br_taken,
    input wire reset,
    input wire inst_ld_Ex,
    input wire inst_ld_Mem,
    input wire calc_ing,
    input wire valid_ID,

    output wire ready_go_IF,
    output wire ready_go_ID,
    output wire ready_go_Ex,
    output wire ready_go_Mem,
    output wire ready_go_WB,
    output wire valid_IF
);
    wire stop_ID,stop_IF,stop_Ex,stop_Mem,stop_WB;
    reg stop_ID_1,stop_ID_2;

    assign ready_go_IF = ready_go_ID & ~stop_IF;
    assign ready_go_ID = ready_go_Ex & ~stop_ID;
    assign ready_go_Ex = ready_go_Mem & ~stop_Ex;
    assign ready_go_Mem = ready_go_WB & ~stop_Mem;
    assign ready_go_WB = ~stop_WB;                  //Automatically stop

    assign stop_IF = 0;
    assign stop_ID = stop_ID_1 | stop_ID_2;
    assign stop_Ex = calc_ing;                      //stop when ALU working
    assign stop_Mem = 0;
    assign stop_WB = 0;
    assign valid_IF = ~br_taken & ~reset;

    always @(*) begin
        if(valid_ID) begin
            if((raddr1==waddr_Ex) && !(waddr_Ex==0) && valid_Ex && wen_Ex && (need_r1_r2 || need_r1)) begin
                if(inst_ld_Ex) begin                   //LoadUse,must stop.
                    stop_ID_1 = 1;
                    forward_source1 = 5'h1;
                end else begin                          //ALU-ALU,forward
                    stop_ID_1 = 0;
                    forward_source1 = 5'h2;
                end
            end else if((raddr1==waddr_Mem) && !(waddr_Mem==0) && valid_Mem && wen_Mem && (need_r1_r2 || need_r1)) begin
                if(inst_ld_Mem) begin                  //LoadUse,but can be solved by using forward
                    stop_ID_1 = 0;
                    forward_source1 = 5'h4;
                end else begin
                    stop_ID_1 = 0;
                    forward_source1 = 5'h8;
                end
            end else if((raddr1==waddr_WB) && !(waddr_WB==0) && valid_WB && wen_WB && (need_r1_r2 || need_r1)) begin
                    stop_ID_1 = 0;
                    forward_source1 = 5'h10;
            end else begin
                stop_ID_1 = 0;
                forward_source1=5'h1;
            end
        end else begin
            stop_ID_1 = 0;
            forward_source1 = 5'h1;
        end
    end

    always @(*) begin
        if(valid_ID) begin
            if((raddr2==waddr_Ex) && !(waddr_Ex==0) && valid_Ex && wen_Ex && need_r1_r2) begin  //same.
                if(inst_ld_Ex) begin
                    stop_ID_2=1;
                    forward_source2 = 5'h1;
                end else begin
                    stop_ID_2 = 0;
                    forward_source2 = 5'h2;
                end
            end else if((raddr2==waddr_Mem) && !(waddr_Mem==0) && valid_Mem && wen_Mem && need_r1_r2) begin
                if(inst_ld_Mem) begin
                    stop_ID_2 = 0;
                    forward_source2 = 5'h4;
                end else begin
                    stop_ID_2 = 0;
                    forward_source2 = 5'h8;
                end
            end else if((raddr2==waddr_WB) && !(waddr_WB==0) && valid_WB && wen_WB && need_r1_r2) begin
                    stop_ID_2 = 0;
                    forward_source2 = 5'h10;
            end else begin
                stop_ID_2 = 0;
                forward_source2=5'h1;
            end
        end else begin
            stop_ID_2 = 0;
            forward_source2 = 5'h1;
        end
    end
    
endmodule

module mycpu_top(
    input  wire        clk,
    input  wire        resetn,
    // inst sram interface
    output wire        inst_sram_en,
    output wire [ 3:0] inst_sram_we,
    output wire [31:0] inst_sram_addr,
    output wire [31:0] inst_sram_wdata,
    input  wire [31:0] inst_sram_rdata,
    // data sram interface
    output wire        data_sram_en,
    output wire [ 3:0] data_sram_we,
    output wire [31:0] data_sram_addr,
    output wire [31:0] data_sram_wdata,
    input  wire [31:0] data_sram_rdata,
    // trace debug interface
    output wire [31:0] debug_wb_pc,
    output wire [ 3:0] debug_wb_rf_we,
    output wire [ 4:0] debug_wb_rf_wnum,
    output wire [31:0] debug_wb_rf_wdata
);

wire valid,
     valid_ID,
     valid_Ex,
     valid_Mem,
     valid_WB;
wire ready_go_IF,
     ready_go_ID,
     ready_go_Ex,
     ready_go_Mem,
     ready_go_WB;

//Clock and reset

reg         reset;
always @(posedge clk) reset <= ~resetn;


//Signal Defination

wire [31:0] seq_pc;
wire [31:0] nextpc;
wire        br_taken;
wire [31:0] br_target;
wire [31:0] inst;       wire [31:0] inst_ID;
reg  [31:0] pc;         wire [31:0] pc_ID; reg [31:0] pc_Ex,pc_Mem,pc_WB;

wire [18:0] alu_op;     wire [18:0] alu_op_Ex;
wire        load_op;                                        //what it is?
wire        src1_is_pc;
wire        src2_is_imm;
wire        res_from_mem,res_from_mem_Ex,res_from_mem_Mem,res_from_mem_WB;
wire        dst_is_r1;
wire        gr_we,gr_we_Ex,gr_we_Mem,gr_we_WB;              //Regfile wen
wire        mem_we;     wire        mem_we_Ex,mem_we_Mem;   //Data SRAM En (Chip Select)
wire        src_reg_is_rd;
wire        rj_eq_rd;
wire        rj_lt_rd;                                       //Rj<Rd(Signed)
wire        rj_lt_rd_u;                                     //Rj<Rd(Unsigned)
wire        read_word,read_word_Ex,read_word_Mem;           //Read a word from Data SRAM
wire        read_halfword,read_halfword_Ex,read_halfword_Mem;//Read half word from Data SRAM
wire        read_byte,read_byte_Ex,read_byte_Mem;           //Read a byte from Data SRAM
wire        read_signed,read_signed_Ex,read_signed_Mem;     //Read : signed expand or zero expand?
wire        write_word,write_word_Ex;
wire        write_halfword,write_halfword_Ex;
wire        write_byte,write_byte_Ex;
wire [1: 0] read_byte_loc,read_byte_loc_Mem;                //which half word or byte we want?
wire [1: 0] write_byte_loc;                                 //which half word or byte we write?
reg  [3: 0] Data_we;                                        //Data SRAM Write Enable(each byte)
reg  [31:0] Data_res;                                       //The Data we get from Data SRAM(after select right bytes and expand)
wire        calc_ing;                                       //ALU busy
wire [4: 0] dest,dest_Ex,dest_Mem,dest_WB;
wire [31:0] rj_value;
wire [31:0] rkd_value;  wire [31:0] rkd_value_Ex,rkd_value_Mem;
wire [31:0] imm;
wire [31:0] br_offs;
wire [31:0] jirl_offs;

wire [ 5:0] op_31_26;
wire [ 3:0] op_25_22;
wire [ 1:0] op_21_20;
wire [ 4:0] op_19_15;
wire [ 4:0] rd;
wire [ 4:0] rj;
wire [ 4:0] rk;
wire [11:0] i12;
wire [19:0] i20;
wire [15:0] i16;
wire [25:0] i26;

wire [63:0] op_31_26_d;
wire [15:0] op_25_22_d;
wire [ 3:0] op_21_20_d;
wire [31:0] op_19_15_d;

wire        inst_add_w;
wire        inst_sub_w;
wire        inst_slt;
wire        inst_sltu;
wire        inst_nor;
wire        inst_and;
wire        inst_or;
wire        inst_xor;
wire        inst_slli_w;
wire        inst_srli_w;
wire        inst_srai_w;
wire        inst_addi_w;
wire        inst_ld_w;
wire        inst_st_w;
wire        inst_jirl;
wire        inst_b;
wire        inst_bl;
wire        inst_beq;
wire        inst_bne;
wire        inst_lu12i_w;
wire        inst_slti;      //new added↓
wire        inst_sltui;
wire        inst_andi;
wire        inst_ori;
wire        inst_xori;
wire        inst_sll_w;
wire        inst_srl_w;
wire        inst_sra_w;
wire        inst_pcaddu12i;
wire        inst_mul_w;
wire        inst_mulh_w;
wire        inst_mulh_wu;
wire        inst_div_w;
wire        inst_div_wu;
wire        inst_mod_w;
wire        inst_mod_wu;
wire        inst_blt;
wire        inst_bge;
wire        inst_bltu;
wire        inst_bgeu;
wire        inst_ld_b;
wire        inst_ld_h;
wire        inst_ld_bu;
wire        inst_ld_hu;
wire        inst_st_b;
wire        inst_st_h;

wire        need_ui5;
wire        need_si12;
wire        need_ui12;
wire        need_si16;
wire        need_si20;
wire        need_si26;
wire        src2_is_4;

wire [ 4:0] rf_raddr1;
wire [31:0] rf_rdata1;
wire [ 4:0] rf_raddr2;
wire [31:0] rf_rdata2;
wire        rf_we   ;
wire [ 4:0] rf_waddr;
wire [31:0] rf_wdata;

wire [31:0] alu_src1   ;    wire [31:0] alu_src1_Ex;
wire [31:0] alu_src2   ;    wire [31:0] alu_src2_Ex;
wire [31:0] alu_result ;    wire [31:0] alu_result_Mem,alu_result_WB;
wire [31:0] final_result;
wire [31:0] mem_result;     wire [31:0] mem_result_WB;

wire [4:0] forward_source1;  //rf_rdata:0x01 alu_res_Ex:0x02 mem_rdata:0x04 alu_res_Mem:0x08 rf_wdata:0x10
wire [4:0] forward_source2;
wire need_r1,need_r1_r2;

//About PC

assign seq_pc       = pc + 32'h4;
assign nextpc       = br_taken ? br_target : seq_pc;

always @(posedge clk) begin
    if (reset) begin
        pc <= 32'h1c000000;     //trick: to make nextpc be 0x1c000000 during reset 
    end
    else if(ready_go_IF) begin
        pc <= nextpc;
    end
end

//Confilct Detecter

ConflictDetecter u_ConflictDetecter(
    .need_r1        (need_r1         ),
    .need_r1_r2     (need_r1_r2      ),
    .waddr_Ex     	(dest_Ex         ),
    .waddr_Mem    	(dest_Mem        ),
    .waddr_WB     	(dest_WB         ),
    .raddr1       	(rf_raddr1       ),
    .raddr2       	(rf_raddr2       ),
    .forward_source1(forward_source1 ),
    .forward_source2(forward_source2 ),
    .valid_Ex     	(valid_Ex        ),
    .valid_Mem    	(valid_Mem       ),
    .valid_WB     	(valid_WB        ),
    .wen_Ex       	(gr_we_Ex        ),
    .wen_Mem      	(gr_we_Mem       ),
    .wen_WB       	(gr_we_WB        ),
    .br_taken     	(br_taken        ),
    .reset          (reset           ),
    .inst_ld_Ex    (res_from_mem_Ex ),
    .inst_ld_Mem   (res_from_mem_Mem),
    .calc_ing       (calc_ing        ),
    .valid_ID       (valid_ID        ),
    .ready_go_IF  	(ready_go_IF     ),
    .ready_go_ID  	(ready_go_ID     ),
    .ready_go_Ex  	(ready_go_Ex     ),
    .ready_go_Mem 	(ready_go_Mem    ),
    .ready_go_WB  	(ready_go_WB     ),
    .valid_IF     	(valid           )
);


//Pipeline Reg

reg  [64:0]  ID_Reg;
reg  [130:0] Ex_Reg;
reg  [78:0]  Mem_Reg;
reg  [71:0]  WB_Reg;
always @(posedge clk) begin
    if (reset) begin
        ID_Reg<=65'b0;
    end else begin
        if(ready_go_ID) begin
            ID_Reg<={valid,pc,inst};
        end else begin
            ID_Reg<=ID_Reg;
        end
    end
end
always @(posedge clk) begin
    if (reset) begin
        Ex_Reg<=131'b0;
    end else begin
        if(ready_go_Ex) begin
            Ex_Reg<={(valid_ID&ready_go_ID),alu_op,alu_src1,alu_src2,rkd_value,mem_we,res_from_mem,dest,gr_we,
                      read_word,read_halfword,read_byte,read_signed,write_word,write_halfword,write_byte};
        end else begin
            Ex_Reg<=Ex_Reg;
        end
    end
end
always @(posedge clk) begin
    if (reset) begin
        Mem_Reg<=79'b0;
    end else begin
        if(ready_go_Mem) begin
            Mem_Reg<={(valid_Ex&ready_go_Ex),alu_result,rkd_value_Ex,mem_we_Ex,res_from_mem_Ex,dest_Ex,gr_we_Ex,
                       read_word_Ex,read_halfword_Ex,read_byte_Ex,read_signed_Ex,read_byte_loc};
        end else begin
            Mem_Reg<=Mem_Reg;
        end
    end
end
always @(posedge clk) begin
    if (reset) begin
        WB_Reg<=72'b0;
    end else begin
        if(ready_go_WB) begin
            WB_Reg<={(valid_Mem&ready_go_Mem),alu_result_Mem,mem_result,res_from_mem_Mem,dest_Mem,gr_we_Mem};
        end else begin
            WB_Reg<=WB_Reg;
        end
    end
end

always @(posedge clk) begin
    if(ready_go_Ex)  pc_Ex<=pc_ID;
    if(ready_go_Mem) pc_Mem<=pc_Ex;
    if(ready_go_WB)  pc_WB<=pc_Mem;
end

//preIF&IF

assign inst_sram_en    = ready_go_IF;
assign inst_sram_we    = 4'b0;
assign inst_sram_addr  = nextpc;
assign inst_sram_wdata = 32'b0;
assign inst            = inst_sram_rdata;

//ID instDecoder

assign {valid_ID,pc_ID,inst_ID} = ID_Reg;
assign op_31_26  = inst_ID[31:26];
assign op_25_22  = inst_ID[25:22];
assign op_21_20  = inst_ID[21:20];
assign op_19_15  = inst_ID[19:15];

assign rd   = inst_ID[ 4: 0];
assign rj   = inst_ID[ 9: 5];
assign rk   = inst_ID[14:10];

assign i12  = inst_ID[21:10];
assign i20  = inst_ID[24: 5];
assign i16  = inst_ID[25:10];
assign i26  = {inst_ID[ 9: 0], inst_ID[25:10]};

decoder_6_64 u_dec0(.in(op_31_26 ), .out(op_31_26_d ));
decoder_4_16 u_dec1(.in(op_25_22 ), .out(op_25_22_d ));
decoder_2_4  u_dec2(.in(op_21_20 ), .out(op_21_20_d ));
decoder_5_32 u_dec3(.in(op_19_15 ), .out(op_19_15_d ));

assign inst_add_w  = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h00];
assign inst_sub_w  = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h02];
assign inst_slt    = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h04];
assign inst_sltu   = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h05];
assign inst_nor    = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h08];
assign inst_and    = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h09];
assign inst_or     = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h0a];
assign inst_xor    = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h0b];
assign inst_slli_w = op_31_26_d[6'h00] & op_25_22_d[4'h1] & op_21_20_d[2'h0] & op_19_15_d[5'h01];
assign inst_srli_w = op_31_26_d[6'h00] & op_25_22_d[4'h1] & op_21_20_d[2'h0] & op_19_15_d[5'h09];
assign inst_srai_w = op_31_26_d[6'h00] & op_25_22_d[4'h1] & op_21_20_d[2'h0] & op_19_15_d[5'h11];
assign inst_addi_w = op_31_26_d[6'h00] & op_25_22_d[4'ha];
assign inst_ld_w   = op_31_26_d[6'h0a] & op_25_22_d[4'h2];
assign inst_st_w   = op_31_26_d[6'h0a] & op_25_22_d[4'h6];
assign inst_jirl   = op_31_26_d[6'h13];
assign inst_b      = op_31_26_d[6'h14];
assign inst_bl     = op_31_26_d[6'h15];
assign inst_beq    = op_31_26_d[6'h16];
assign inst_bne    = op_31_26_d[6'h17];
assign inst_lu12i_w= op_31_26_d[6'h05] & ~inst_ID[25];
assign inst_slti   = op_31_26_d[6'h00] & op_25_22_d[4'h8];      //new added↓
assign inst_sltui  = op_31_26_d[6'h00] & op_25_22_d[4'h9];
assign inst_andi   = op_31_26_d[6'h00] & op_25_22_d[4'hd];
assign inst_ori    = op_31_26_d[6'h00] & op_25_22_d[4'he];
assign inst_xori   = op_31_26_d[6'h00] & op_25_22_d[4'hf];
assign inst_sll_w  = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h0e];
assign inst_srl_w  = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h0f];
assign inst_sra_w  = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h10];
assign inst_pcaddu12i=op_31_26_d[6'h07] & ~inst_ID[25];
assign inst_mul_w  = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h18];
assign inst_mulh_w = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h19];
assign inst_mulh_wu= op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h1a];
assign inst_div_w  = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h2] & op_19_15_d[5'h00];
assign inst_div_wu = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h2] & op_19_15_d[5'h02];
assign inst_mod_w  = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h2] & op_19_15_d[5'h01];
assign inst_mod_wu = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h2] & op_19_15_d[5'h03];
assign inst_blt    = op_31_26_d[6'h18];
assign inst_bge    = op_31_26_d[6'h19];
assign inst_bltu   = op_31_26_d[6'h1a];
assign inst_bgeu   = op_31_26_d[6'h1b];
assign inst_ld_b   = op_31_26_d[6'h0a] & op_25_22_d[4'h0];
assign inst_ld_h   = op_31_26_d[6'h0a] & op_25_22_d[4'h1];
assign inst_ld_bu  = op_31_26_d[6'h0a] & op_25_22_d[4'h8];
assign inst_ld_hu  = op_31_26_d[6'h0a] & op_25_22_d[4'h9];
assign inst_st_b   = op_31_26_d[6'h0a] & op_25_22_d[4'h4];
assign inst_st_h   = op_31_26_d[6'h0a] & op_25_22_d[4'h5];

assign alu_op[ 0] = inst_add_w  | inst_addi_w | inst_ld_w | inst_st_w
                    | inst_jirl | inst_bl     | inst_ld_b | inst_ld_h
                    | inst_ld_bu| inst_ld_hu  | inst_st_b | inst_st_h
                    | inst_pcaddu12i;
assign alu_op[ 1] = inst_sub_w;
assign alu_op[ 2] = inst_slt    | inst_slti;
assign alu_op[ 3] = inst_sltu   | inst_sltui;
assign alu_op[ 4] = inst_and    | inst_andi;
assign alu_op[ 5] = inst_nor;
assign alu_op[ 6] = inst_or     | inst_ori;
assign alu_op[ 7] = inst_xor    | inst_xori;
assign alu_op[ 8] = inst_slli_w | inst_sll_w;
assign alu_op[ 9] = inst_srli_w | inst_srl_w;
assign alu_op[10] = inst_srai_w | inst_sra_w;
assign alu_op[11] = inst_lu12i_w;
assign alu_op[12] = inst_mul_w;
assign alu_op[13] = inst_mulh_w;
assign alu_op[14] = inst_mulh_wu;
assign alu_op[15] = inst_div_w;
assign alu_op[16] = inst_div_wu;
assign alu_op[17] = inst_mod_w;
assign alu_op[18] = inst_mod_wu;

assign read_word = inst_ld_w;                               //RW Signals
assign read_halfword = inst_ld_h | inst_ld_hu;
assign read_byte = inst_ld_b | inst_ld_bu;
assign read_signed = inst_ld_w | inst_ld_h | inst_ld_b;
assign write_word = inst_st_w;
assign write_halfword = inst_st_h;
assign write_byte = inst_st_b;
assign write_byte_loc = alu_result[1:0];
assign read_byte_loc = alu_result[1:0];

assign need_ui5   =  inst_slli_w | inst_srli_w | inst_srai_w;                           //Using to imm expand
assign need_si12  =  inst_addi_w | inst_ld_w   | inst_st_w | inst_slti 
                   | inst_sltui  | inst_ld_b   | inst_ld_h | inst_ld_bu
                   | inst_ld_hu  | inst_st_b   | inst_st_h ;
assign need_ui12  =  inst_andi   | inst_ori    | inst_xori;
assign need_si16  =  inst_jirl   | inst_beq    | inst_bne | inst_blt | inst_bltu | inst_bge | inst_bgeu;
assign need_si20  =  inst_lu12i_w| inst_pcaddu12i;
assign need_si26  =  inst_b      | inst_bl;
assign src2_is_4  =  inst_jirl   | inst_bl;

assign need_r1 = inst_addi_w   | inst_ld_w   | inst_jirl | inst_slli_w                  //Using to detect a conflict
                 | inst_srli_w | inst_srai_w | inst_slti | inst_sltui
                 | inst_andi   | inst_ori    | inst_xori | inst_ld_b 
                 | inst_ld_h   | inst_ld_bu  | inst_ld_hu| inst_st_b 
                 | inst_st_h   ;
assign need_r1_r2 = inst_add_w | inst_sub_w  | inst_st_w | inst_bne 
                 | inst_beq    | inst_slt    | inst_sltu | inst_and 
                 | inst_or     | inst_nor    | inst_xor  | inst_sll_w
                 | inst_srl_w  | inst_sra_w  | inst_mul_w| inst_mulh_w
                 | inst_mulh_wu| inst_div_w  | inst_mod_w| inst_div_wu
                 | inst_mod_wu | inst_blt    | inst_bge  | inst_bltu
                 | inst_bgeu   ;

assign src_reg_is_rd = inst_beq | inst_bne | inst_st_w | inst_blt | inst_bltu | inst_bge | inst_bgeu | inst_st_b | inst_st_h;

assign src1_is_pc    = inst_jirl | inst_bl | inst_pcaddu12i;

assign src2_is_imm   = inst_slli_w |
                       inst_srli_w |
                       inst_srai_w |
                       inst_addi_w |
                       inst_ld_w   |
                       inst_st_w   |
                       inst_lu12i_w|
                       inst_jirl   |
                       inst_bl     |
                       inst_slti   |
                       inst_sltui  |
                       inst_andi   |
                       inst_ori    |
                       inst_xori   |
                       inst_ld_b   | 
                       inst_ld_h   |
                       inst_ld_bu  |
                       inst_ld_hu  |
                       inst_st_b   |
                       inst_st_h   |
                       inst_pcaddu12i;

assign res_from_mem  = inst_ld_w| inst_ld_b   | inst_ld_h | inst_ld_bu | inst_ld_hu ;
assign dst_is_r1     = inst_bl;
assign gr_we         = ~inst_st_w & ~inst_beq & ~inst_bne & ~inst_b & ~inst_blt & ~inst_bge & ~inst_bltu & ~inst_bgeu & ~inst_st_h & ~inst_st_b;
assign mem_we        = inst_st_w | inst_st_h | inst_st_b;
assign dest          = dst_is_r1 ? 5'd1 : rd;

assign rf_raddr1 = rj;
assign rf_raddr2 = src_reg_is_rd ? rd :rk;

//imm expand

assign imm = src2_is_4 ? 32'h4                      :
             need_si20 ? {i20[19:0], 12'b0}         :
             need_ui5  ? {27'b0, rk}                :
             need_si12 ?{{20{i12[11]}}, i12[11:0]}  :
                        {20'b0, i12[11:0]}          ;

//calc br_target

assign br_offs = need_si26 ? {{ 4{i26[25]}}, i26[25:0], 2'b0} :
                             {{14{i16[15]}}, i16[15:0], 2'b0} ;

assign jirl_offs = {{14{i16[15]}}, i16[15:0], 2'b0};

assign rj_eq_rd = (rj_value == rkd_value);
assign rj_lt_rd = ($signed(rj_value) < $signed(rkd_value));
assign rj_lt_rd_u = ($unsigned(rj_value) < $unsigned(rkd_value));
assign br_taken = (   inst_beq  &&  rj_eq_rd
                   || inst_bne  && !rj_eq_rd
                   || inst_blt  &&  rj_lt_rd
                   || inst_bge  && !rj_lt_rd
                   || inst_bltu &&  rj_lt_rd_u
                   || inst_bgeu && !rj_lt_rd_u
                   || inst_jirl
                   || inst_bl
                   || inst_b
                  ) && valid_ID;
assign br_target = (inst_beq || inst_bne || inst_bl || inst_b || inst_blt || inst_bge || inst_bltu || inst_bgeu) ?
                                                                 (pc_ID + br_offs) :
                                                   /*inst_jirl*/ (rj_value + jirl_offs);

//RegFile

regfile u_regfile(
    .clk    (clk      ),
    .raddr1 (rf_raddr1),
    .rdata1 (rf_rdata1),
    .raddr2 (rf_raddr2),
    .rdata2 (rf_rdata2),
    .we     (rf_we    ),
    .waddr  (rf_waddr ),
    .wdata  (rf_wdata )
    );

assign rj_value  = (forward_source1==5'h1)? rf_rdata1:          //Forward Mux
                   (forward_source1==5'h2)? alu_result:
                   (forward_source1==5'h4)? mem_result:
                   (forward_source1==5'h8)? alu_result_Mem:
                                            rf_wdata;
assign rkd_value = (forward_source2==5'h1)? rf_rdata2:
                   (forward_source2==5'h2)? alu_result:
                   (forward_source2==5'h4)? mem_result:
                   (forward_source2==5'h8)? alu_result_Mem:
                                            rf_wdata;

assign alu_src1 = src1_is_pc  ? pc_ID[31:0] : rj_value;
assign alu_src2 = src2_is_imm ? imm : rkd_value;

//Ex

assign {valid_Ex,alu_op_Ex,alu_src1_Ex,alu_src2_Ex,rkd_value_Ex,mem_we_Ex,res_from_mem_Ex,dest_Ex,gr_we_Ex,
        read_word_Ex,read_halfword_Ex,read_byte_Ex,read_signed_Ex,write_word_Ex,write_halfword_Ex,write_byte_Ex} = Ex_Reg;

alu u_alu(
    .clk        (clk          ),
    .valid_Ex   (valid_Ex     ),
    .reset      (reset        ),
    .alu_op     (alu_op_Ex    ),
    .alu_src1   (alu_src1_Ex  ),
    .alu_src2   (alu_src2_Ex  ),
    .alu_result (alu_result   ),
    .calc_ing   (calc_ing     )
    );

always @(*) begin                               //Data SRAM write config
    if(write_byte_Ex) begin
        Data_we = (write_byte_loc==0)? 4'h1:
                  (write_byte_loc==1)? 4'h2:
                  (write_byte_loc==2)? 4'h4:
                                       4'h8;
    end else if(write_halfword_Ex) begin
        Data_we = (write_byte_loc==0)? 4'h3:
                                       4'hc;
    end else begin
        Data_we = 4'hf;
    end
end

assign data_sram_en    = 1'b1;
assign data_sram_we    = Data_we & {4{mem_we_Ex & valid_Ex}};
assign data_sram_addr  = alu_result;
assign data_sram_wdata = write_byte_Ex     ? {4{rkd_value_Ex[7:0]}} :
                         write_halfword_Ex ? {2{rkd_value_Ex[15:0]}} :
                                            rkd_value_Ex;

//Mem

assign {valid_Mem,alu_result_Mem,rkd_value_Mem,mem_we_Mem,res_from_mem_Mem,dest_Mem,gr_we_Mem,
        read_word_Mem,read_halfword_Mem,read_byte_Mem,read_signed_Mem,read_byte_loc_Mem} = Mem_Reg;
always @(*) begin                                                                                           //Data SRAM read config
    if(read_byte_Mem) begin
        Data_res = (read_byte_loc_Mem==0)? {{24{read_signed_Mem&data_sram_rdata[7]}},data_sram_rdata[7:0]}:
                   (read_byte_loc_Mem==1)? {{24{read_signed_Mem&data_sram_rdata[15]}},data_sram_rdata[15:8]}:
                   (read_byte_loc_Mem==2)? {{24{read_signed_Mem&data_sram_rdata[23]}},data_sram_rdata[23:16]}:
                                           {{24{read_signed_Mem&data_sram_rdata[31]}},data_sram_rdata[31:24]};
    end else if(read_halfword_Mem) begin
        Data_res = (read_byte_loc_Mem==0)? {{16{read_signed_Mem&data_sram_rdata[15]}},data_sram_rdata[15:0]}:
                                           {{16{read_signed_Mem&data_sram_rdata[31]}},data_sram_rdata[31:16]};
    end else begin
        Data_res = data_sram_rdata;
    end
end
assign mem_result   = Data_res;

//WB

assign {valid_WB,alu_result_WB,mem_result_WB,res_from_mem_WB,dest_WB,gr_we_WB} = WB_Reg;
assign final_result = res_from_mem_WB ? mem_result_WB : alu_result_WB;
assign rf_we    = gr_we_WB && valid_WB;
assign rf_waddr = dest_WB;
assign rf_wdata = final_result;

// debug info generate
assign debug_wb_pc       = pc_WB;
assign debug_wb_rf_we   = {4{rf_we}};
assign debug_wb_rf_wnum  = dest_WB;
assign debug_wb_rf_wdata = final_result;

endmodule

`timescale 1ns / 1ps
`default_nettype none
//------------------------------------------------------------------------------
// Endianess
// 0 -> little-endian. 1 -> big-endian
//------------------------------------------------------------------------------
`define LITTLE_ENDIAN      0                   //
`define BIG_ENDIAN         1                   //

//------------------------------------------------------------------------------
// Exception Vector
//------------------------------------------------------------------------------
`define VECTOR_BASE_RESET      32'h0000_0010   // MIPS Standard is 0xBFC0_0000. Reset, soft-reset, NMI
`define VECTOR_BASE_BOOT       32'h0000_0000   // MIPS Standard is 0xBFC0_0200. Bootstrap (Status_BEV = 1)
`define VECTOR_BASE_NO_BOOT    32'h0000_0000   // MIPS Standard is 0x8000_0000. Normal (Status_BEV = 0)
`define VECTOR_OFFSET_GENERAL  32'h0000_0000   // MIPS Standard is 0x0000_0180. General exception, but TBL
`define VECTOR_OFFSET_SPECIAL  32'h0000_0008   // MIPS Standard is 0x0000_0200. Interrupts (Cause_IV = 1)

//------------------------------------------------------------------------------
/*
    Encoding for the MIPS Release 1 Architecture

    3 types of instructions:
        - R   : Register-Register
        - I   : Register-Immediate
        - J   : Jump

    Format:
    ------
        - R : Opcode(6) + Rs(5) + Rt(5) + Rd(5) + shamt(5) +  function(6)
        - I : Opcode(6) + Rs(5) + Rt(5) + Imm(16)
        - J : Opcode(6) + Imm(26)
*/
//------------------------------------------------------------------------------
// Opcode field for special instructions
//------------------------------------------------------------------------------
`define OP_TYPE_R               6'b00_0000          // Special
`define OP_TYPE_REGIMM          6'b00_0001          // Branch/Trap

//------------------------------------------------------------------------------
// Instructions fields
//------------------------------------------------------------------------------
`define INSTR_OPCODE            31:26
`define INSTR_RS                25:21
`define INSTR_RT                20:16
`define INSTR_RD                15:11
`define INSTR_SHAMT             10:6
`define INSTR_FUNCT             5:0
`define INSTR_IMM16             15:0
`define INSTR_IMM26             25:0

//------------------------------------------------------------------------------
// Opcode list
//------------------------------------------------------------------------------
`define OP_ADDI                 6'b00_1000
`define OP_ADDIU                6'b00_1001
`define OP_ANDI                 6'b00_1100
`define OP_BEQ                  6'b00_0100
`define OP_BGEZ                 `OP_TYPE_REGIMM
`define OP_BGEZAL               `OP_TYPE_REGIMM
`define OP_BGTZ                 6'b00_0111
`define OP_BLEZ                 6'b00_0110
`define OP_BLTZ                 `OP_TYPE_REGIMM
`define OP_BLTZAL               `OP_TYPE_REGIMM
`define OP_BNE                  6'b00_0101
`define OP_J                    6'b00_0010
`define OP_JAL                  6'b00_0011
`define OP_LB                   6'b10_0000
`define OP_LBU                  6'b10_0100
`define OP_LH                   6'b10_0001
`define OP_LHU                  6'b10_0101
`define OP_LL                   6'b11_0000
`define OP_LUI                  6'b00_1111
`define OP_LW                   6'b10_0011
`define OP_ORI                  6'b00_1101
`define OP_SB                   6'b10_1000
`define OP_SH                   6'b10_1001
`define OP_SLTI                 6'b00_1010
`define OP_SLTIU                6'b00_1011
`define OP_SW                   6'b10_1011
`define OP_XORI                 6'b00_1110

//------------------------------------------------------------------------------
// Function field for R(2)-type instructions
//------------------------------------------------------------------------------
`define FUNCTION_OP_ADD         6'b10_0000
`define FUNCTION_OP_ADDU        6'b10_0001
`define FUNCTION_OP_AND         6'b10_0100
`define FUNCTION_OP_BREAK       6'b00_1101
`define FUNCTION_OP_CLO         6'b10_0001
`define FUNCTION_OP_CLZ         6'b10_0000
`define FUNCTION_OP_DIV         6'b01_1010
`define FUNCTION_OP_DIVU        6'b01_1011
`define FUNCTION_OP_JALR        6'b00_1001
`define FUNCTION_OP_JR          6'b00_1000
`define FUNCTION_OP_MFHI        6'b01_0000
`define FUNCTION_OP_MFLO        6'b01_0010
`define FUNCTION_OP_MOVN        6'b00_1011
`define FUNCTION_OP_MOVZ        6'b00_1010
`define FUNCTION_OP_MSUB        6'b00_0100
`define FUNCTION_OP_MSUBU       6'b00_0101
`define FUNCTION_OP_MTHI        6'b01_0001
`define FUNCTION_OP_MTLO        6'b01_0011
`define FUNCTION_OP_MULT        6'b01_1000
`define FUNCTION_OP_MULTU       6'b01_1001
`define FUNCTION_OP_NOR         6'b10_0111
`define FUNCTION_OP_OR          6'b10_0101
`define FUNCTION_OP_SLL         6'b00_0000
`define FUNCTION_OP_SLLV        6'b00_0100
`define FUNCTION_OP_SLT         6'b10_1010
`define FUNCTION_OP_SLTU        6'b10_1011
`define FUNCTION_OP_SRA         6'b00_0011
`define FUNCTION_OP_SRAV        6'b00_0111
`define FUNCTION_OP_SRL         6'b00_0010
`define FUNCTION_OP_SRLV        6'b00_0110
`define FUNCTION_OP_SUB         6'b10_0010
`define FUNCTION_OP_SUBU        6'b10_0011
`define FUNCTION_OP_SYSCALL     6'b00_1100
`define FUNCTION_OP_XOR         6'b10_0110
// from this point on, these are created by Khalil Estell
`define PSUEDO_LOAD_UPPER   6'b11_1101

//------------------------------------------------------------------------------
// Branch >/< zero (and link), traps: Rt
//------------------------------------------------------------------------------
`define RT_OP_BGEZ              5'b00001
`define RT_OP_BGEZAL            5'b10001
`define RT_OP_BLTZ              5'b00000
`define RT_OP_BLTZAL            5'b10000
`define RT_OP_TEQI              5'b01100
`define RT_OP_TGEI              5'b01000
`define RT_OP_TGEIU             5'b01001
`define RT_OP_TLTI              5'b01010
`define RT_OP_TLTIU             5'b01011
`define RT_OP_TNEI              5'b01110

//------------------------------------------------------------------------------
// Rs field for Coprocessor instructions
//------------------------------------------------------------------------------
`define RS_OP_MFC               5'b00000
`define RS_OP_MTC               5'b00100

//------------------------------------------------------------------------------
// ERET
//------------------------------------------------------------------------------
`define RS_OP_ERET              5'b10000
`define FUNCTION_OP_ERET        6'b01_1000

//------------------------------------------------------------------------------
// SYSTEM CONSTANTS
//------------------------------------------------------------------------------
`define OP_CODE_WIDTH           6
`define ALU_FUNCTION_WIDTH      6
`define ALU_OP_CODE_WIDTH       `ALU_FUNCTION_WIDTH
`define FUNCTION_WIDTH          6
`define REGISTER_WIDTH          32
`define NUMBER_OF_REGISTERS     32
`define STACK_POINTER           29
`define INSTRUCTION_WIDTH       32
`define RETURN_ADDRESS_REGISTER 31

module MIPS(
    input wire clk,
    input wire rst,
    output wire BusCycle,
    output wire [3:0] MemWrite,
    output wire MemRead,
    output wire [`REGISTER_WIDTH-1:0] AddressBus,
    output wire [`REGISTER_WIDTH-1:0] DataBus,
    output wire [`REGISTER_WIDTH-1:0] ProgramCounter,
    output wire [`REGISTER_WIDTH-1:0] ALUResult,
    output wire [`REGISTER_WIDTH-1:0] RegOut1,
    output wire [`REGISTER_WIDTH-1:0] RegOut2,
    output wire [`REGISTER_WIDTH-1:0] RegWriteData,
    output wire [`REGISTER_WIDTH-1:0] RegWriteAddress,
    input wire  [`REGISTER_WIDTH-1:0] Instruction
);
// ==================================
//// Internal Parameter Field
// ==================================
parameter BYTE = 2'd2;
parameter HALF = 2'd1;
parameter WORD = 2'd0;
// ==================================
//// Wire Assignments
// ==================================
assign AddressBus                   = (BusCycle) ? alu_result : `REGISTER_WIDTH'b0;
assign ALUResult                    = alu_result;
assign ProgramCounter               = pc;
assign mips_instruction             = Instruction;
assign RegOut1                      = read_data_1;
assign RegOut2                      = read_data_2;
assign RegWriteData                 = write_data;
assign RegWriteAddress              = write_address;
assign data_out_bus_select          = (MemWrite == 4'b1111) ? WORD : (MemWrite == 4'b0011 || MemWrite == 4'b1100) ? HALF : BYTE;
// ==================================
//// Wires
// ==================================
//// Instructions
wire [`INSTRUCTION_WIDTH-1:0] mips_instruction;
// R-type instruction
wire [ 5:0] opcode                 = mips_instruction[`INSTR_OPCODE];
wire [ 4:0] register_source        = mips_instruction[`INSTR_RS];
wire [ 4:0] register_target        = mips_instruction[`INSTR_RT];
wire [ 4:0] register_destination   = mips_instruction[`INSTR_RD];
wire [ 4:0] shift_amount           = mips_instruction[`INSTR_SHAMT];
wire [ 5:0] funct                  = mips_instruction[`INSTR_FUNCT];
// I-type instruction field
wire [15:0] immediate              = mips_instruction[`INSTR_IMM16];
// J-type instruction field
wire [25:0] jump_address           = mips_instruction[`INSTR_IMM26];
//// Program Counter Datapath Signals
wire [`REGISTER_WIDTH-1:0] final_pc;
wire [`REGISTER_WIDTH-1:0] next_pc;
wire [`REGISTER_WIDTH-1:0] branch_pc_offset;
wire [`REGISTER_WIDTH-1:0] branch_pc_offset_sign_extended;
wire [`REGISTER_WIDTH-1:0] branch_pc;
wire [`REGISTER_WIDTH-1:0] pc;
//// Decoder Control Signals
wire [`ALU_OP_CODE_WIDTH-1:0] ALUOp;
wire [1:0] RegInSelect;
wire [1:0] RegWriteDst;
wire [1:0] PCSrc;
wire ALUSrc;
wire RegWrite;
wire SignExtImm;
//// ALU signals
wire [`REGISTER_WIDTH-1:0] alu_b;
wire [`REGISTER_WIDTH-1:0] alu_result;
wire [`REGISTER_WIDTH-1:0] memory_to_reg_data;
wire zero;
wire tribuffer_enable;
wire less_than_eq;
wire greater_than;
//// Register File Signals
wire [`REGISTER_WIDTH-1:0] read_data_1;
wire [`REGISTER_WIDTH-1:0] read_data_2;
wire [$clog2(`NUMBER_OF_REGISTERS)-1:0] write_address;
wire [`REGISTER_WIDTH-1:0] immediate_extended;
wire [`REGISTER_WIDTH-1:0] DataBusByteShifted;
wire [`REGISTER_WIDTH-1:0] DataBusByte = DataBusByteShifted & 8'hFF;
wire [`REGISTER_WIDTH-1:0] write_data;
//// DataBus data control signals
wire [1:0] data_out_bus_select;
wire [`REGISTER_WIDTH-1:0] data_out;

PROCESSOR_DECODER decoder(
    .opcode(opcode),
    .funct(funct),
    .alu_result(alu_result),
    .zero(zero),
    .less_than_eq(less_than_eq),
    .greater_than(greater_than),
    .BusCycle(BusCycle),
    .RegWriteDst(RegWriteDst),
    .RegInSelect(RegInSelect),
    .PCSrc(PCSrc),
    .ALUSrc(ALUSrc),
    .SignExtImm(SignExtImm),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .ALUOp(ALUOp)
);

REGISTER #(.WIDTH(`REGISTER_WIDTH)) pc_register (
	.rst(rst),
	.clk(clk),
	.load(1'b1),
	.D(final_pc),
	.Q(pc)
);

ADDER #(.WIDTH(`REGISTER_WIDTH)) adder (
	.a(pc),
    .b(32'h4),
	.y(next_pc)
);

MUX #(
    .WIDTH($clog2(`NUMBER_OF_REGISTERS)),
    .INPUTS(3)
) register_destination_mux (
    .select(RegWriteDst),
    .in({ `RETURN_ADDRESS_REGISTER, register_target, register_destination }),
    .out(write_address)
);

REGFILE regfile(
	.clk(clk),
	.read_address_1(register_source),
    .read_address_2(register_target),
    .write_address(write_address),
	.write_enable(RegWrite),
	.write_data(write_data),
	.read_data_1(read_data_1),
    .read_data_2(read_data_2)
);


VALUE_EXTEND #(
    .INPUT_WIDTH(16),
    .OUTPUT_WIDTH(`REGISTER_WIDTH)
) sign_extend_immediate (
    .sign_extend(SignExtImm),
	.a(immediate),
	.y(immediate_extended)

);

SHIFT_LEFT #(.AMOUNT(2))
branch_shift_immediate
(
	.a(immediate_extended),

    .y(branch_pc_offset)
);

VALUE_EXTEND #(
    .INPUT_WIDTH(16),
    .OUTPUT_WIDTH(`REGISTER_WIDTH)
) branch_pc_offset_sign_extend
(
    .sign_extend(1),
	.a(branch_pc_offset),
	.y(branch_pc_offset_sign_extended)
);

ADDER #(.WIDTH(`REGISTER_WIDTH)) branch_pc_adder (
	.a(branch_pc_offset_sign_extended),
    .b(next_pc),
	.y(branch_pc)
);

MUX #(
    .WIDTH(`REGISTER_WIDTH),
    .INPUTS(4)
) final_pc_mux (
    .select(PCSrc),
    .in({ alu_result, branch_pc_offset, branch_pc, next_pc }),
    .out(final_pc)
);

MUX #(
    .WIDTH(`REGISTER_WIDTH),
    .INPUTS(2)
) alu_source_mux (
    .select(ALUSrc),
    .in({immediate_extended, read_data_2}),

    .out(alu_b)
);

ALU alu(
    .clk(clk),
    .a(read_data_1),
    .b(alu_b),
    .ALUOp(ALUOp),
    .shift_amount(shift_amount),
    .result(alu_result),
    .zero(zero),
    .less_than_eq(less_than_eq),
    .greater_than(greater_than)
);

OR #(.WIDTH(4)
) mem_write_or (
    .in(MemWrite),
    .out(tribuffer_enable)
);

MUX #(
    .WIDTH(`REGISTER_WIDTH),
    .INPUTS(3)
) data_out_bus_mux (
    .select(data_out_bus_select),
    .in({
        { read_data_2[ 7:0], read_data_2[7:0], read_data_2[ 7:0], read_data_2[7:0] },
        { read_data_2[15:8], read_data_2[7:0], read_data_2[15:8], read_data_2[7:0] },
        read_data_2
    }),
    .out(data_out)
);

TRIBUFFER #(.WIDTH(`REGISTER_WIDTH)
) buffer_databus (
	.oe(tribuffer_enable),
	.in(data_out),
	.out(DataBus)
);

//========================================
// Shift and And Data Write for LB and LH
//========================================

SHIFT_RIGHT #(.WIDTH(`REGISTER_WIDTH)
) shift_data_memory_by_address_offset (
	.a(DataBus),
    .b({ {(`REGISTER_WIDTH-5){1'b0}}, AddressBus[1:0], 3'b0 }),
	.y(DataBusByteShifted)
);

MUX #(
    .WIDTH(`REGISTER_WIDTH),
    .INPUTS(4)
) final_stage_write_data (
    .select(RegInSelect),
    .in({
        DataBusByte,
        next_pc,
        DataBus,
        alu_result
    }),
    .out(write_data)
);

// ==================================
//// Registers
// ==================================
// ==================================
//// Behavioral Block
// ==================================

endmodule

module PROCESSOR_DECODER(
    input wire [`OP_CODE_WIDTH-1:0]  opcode,
    input wire [`FUNCTION_WIDTH-1:0] funct,
    input wire [`REGISTER_WIDTH-1:0] alu_result,
    input wire                      zero,
    input wire                      less_than_eq,
    input wire                      greater_than,
    output wire                     BusCycle,
    output reg [1:0]                RegWriteDst,
    output reg [1:0]                RegInSelect,
    output reg [1:0]                PCSrc,
    output reg                      ALUSrc,
    output reg                      SignExtImm,
    output reg                      RegWrite,
    output reg [3:0]                MemWrite,
    output reg                      MemRead,
    output reg [`ALU_OP_CODE_WIDTH-1:0]  ALUOp
);

// output reg                      MemToReg,
// output reg                      Jump,
// output reg                      RegisterJump,
// output reg                      LoadByte,
// output reg                      PCToReg,

assign BusCycle = (MemRead | (|MemWrite));

`define ALUSRC_FOR_RTYPE            0
`define ALUSRC_FOR_ITYPE            1

`define REGWRITEDST_FROM_RTYPE      0
`define REGWRITEDST_FROM_ITYPE      1
`define REGWRITEDST_RETURN_ADDR     2

`define PCSRC_NEXT_PC               0
`define PCSRC_BRANCH_PC             1
`define PCSRC_JUMP_PC_IMMEDIATE     2
`define PCSRC_JUMP_PC_REGISTER      3

`define REGIN_ALU_RESULT            0
`define REGIN_DATABUS               1
`define REGIN_STORE_NEXT_PC         2
`define REGIN_DATABUS_BYTE_ACCESS   3

`define ALU_NULL_OPCODE             `ALU_OP_CODE_WIDTH'b0

`define UNSUPPORTED_OPERATIONS   \
            RegWrite    <= 1'bx; \
            SignExtImm  <= 1'bx; \
            RegWriteDst <= 1'bx; \
            ALUSrc      <= 1'bx; \
            RegInSelect <= 1'bx; \
            PCSrc       <= 1'bx; \
            MemWrite    <= 1'bx; \
            MemRead     <= 1'bx; \
            ALUOp       <= 1'bx

wire [`ALU_OP_CODE_WIDTH-1:0] immediate_funct;

IMMEDIATE_TO_ALU_CONVERTER imm_to_alu (
    .opcode(opcode),
    .instruction_function(funct),
    .alu_funct(immediate_funct)
);

always @(*)
begin
    case(opcode)
        `OP_TYPE_R: begin
            RegWrite    <= 1;
            SignExtImm  <= 0;
            RegWriteDst <= `REGWRITEDST_FROM_RTYPE;
            ALUSrc      <= `ALUSRC_FOR_RTYPE;
            RegInSelect <= `REGIN_ALU_RESULT;
            case(funct)
                `FUNCTION_OP_JR,
                `FUNCTION_OP_JALR: begin
                    PCSrc       <= `PCSRC_JUMP_PC_REGISTER;
                end
                default: begin
                    PCSrc       <= 0;
                end
            endcase
            MemWrite    <= 0;
            MemRead     <= 0;
            ALUOp       <= funct;
        end
        `OP_ADDI,
        `OP_ADDIU,
        `OP_SLTI,
        `OP_SLTIU,
        `OP_LUI: begin
            RegWrite    <= 1;
            SignExtImm  <= 1;
            RegWriteDst <= `REGWRITEDST_FROM_ITYPE;
            ALUSrc      <= `ALUSRC_FOR_ITYPE;
            RegInSelect <= `REGIN_ALU_RESULT;
            PCSrc       <= 0;
            MemWrite    <= 0;
            MemRead     <= 0;
            ALUOp       <= immediate_funct;
        end
        `OP_ANDI,
        `OP_ORI,
        `OP_XORI: begin
            RegWrite    <= 1;
            SignExtImm  <= 0;
            RegWriteDst <= `REGWRITEDST_FROM_ITYPE;
            ALUSrc      <= `ALUSRC_FOR_ITYPE;
            RegInSelect <= `REGIN_ALU_RESULT;
            PCSrc       <= 0;
            MemWrite    <= 0;
            MemRead     <= 0;
            ALUOp       <= immediate_funct;
        end
        `OP_BEQ: begin
            RegWrite    <= 0;
            SignExtImm  <= 0;
            RegWriteDst <= 0;
            ALUSrc      <= 0;
            RegInSelect <= 0;
            PCSrc       <= (zero) ? `PCSRC_BRANCH_PC : `PCSRC_NEXT_PC;
            MemWrite    <= 0;
            MemRead     <= 0;
            ALUOp       <= `FUNCTION_OP_SUB;
        end
        `OP_BNE: begin
            RegWrite    <= 0;
            SignExtImm  <= 0;
            RegWriteDst <= 0;
            ALUSrc      <= 0;
            RegInSelect <= 0;
            PCSrc       <= (!zero) ? `PCSRC_BRANCH_PC : `PCSRC_NEXT_PC;
            MemWrite    <= 0;
            MemRead     <= 0;
            ALUOp       <= `FUNCTION_OP_SUB;
        end
        `OP_BGTZ: begin
            RegWrite    <= 0;
            SignExtImm  <= 0;
            RegWriteDst <= 0;
            ALUSrc      <= 0;
            RegInSelect <= 0;
            PCSrc       <= (greater_than) ? `PCSRC_BRANCH_PC : `PCSRC_NEXT_PC;
            MemWrite    <= 0;
            MemRead     <= 0;
            ALUOp       <= `FUNCTION_OP_SUB;
        end
        `OP_BLEZ: begin
            RegWrite    <= 0;
            SignExtImm  <= 0;
            RegWriteDst <= 0;
            ALUSrc      <= 0;
            RegInSelect <= 0;
            PCSrc       <= (less_than_eq) ? `PCSRC_BRANCH_PC : `PCSRC_NEXT_PC;
            MemWrite    <= 0;
            MemRead     <= 0;
            ALUOp       <= `FUNCTION_OP_SUB;
        end
        `OP_BGEZAL,
        `OP_BLTZAL: begin
            `UNSUPPORTED_OPERATIONS;
        end
        `OP_J: begin
            RegWrite    <= 0;
            SignExtImm  <= 0;
            RegWriteDst <= 0;
            ALUSrc      <= 0;
            RegInSelect <= 0;
            PCSrc       <= `PCSRC_JUMP_PC_IMMEDIATE;
            MemWrite    <= 0;
            MemRead     <= 0;
            ALUOp       <= `ALU_NULL_OPCODE;
        end
        `OP_JAL: begin
            RegWrite    <= 1;
            SignExtImm  <= 0;
            RegWriteDst <= `REGWRITEDST_RETURN_ADDR;
            ALUSrc      <= 0;
            RegInSelect <= `REGIN_STORE_NEXT_PC;
            PCSrc       <= `PCSRC_JUMP_PC_IMMEDIATE;
            MemWrite    <= 0;
            MemRead     <= 0;
            ALUOp       <= `ALU_NULL_OPCODE;
        end
        `OP_LH,
        `OP_LHU,
        `OP_LL:begin
            `UNSUPPORTED_OPERATIONS;
        end
        /* TODO: LB AND LW NOT PROPERLY SIGN EXTENDED!! */
        `OP_LBU,
        `OP_LB: begin
            RegWrite    <= 1;
            SignExtImm  <= 0;
            RegWriteDst <= `REGWRITEDST_FROM_ITYPE;
            ALUSrc      <= `ALUSRC_FOR_ITYPE;
            RegInSelect <= `REGIN_DATABUS_BYTE_ACCESS;
            PCSrc       <= 0;
            MemWrite    <= 0;
            MemRead     <= 1;
            ALUOp       <= `FUNCTION_OP_ADD;
        end
        `OP_LW: begin
            RegWrite    <= 1;
            SignExtImm  <= 0;
            RegWriteDst <= `REGWRITEDST_FROM_ITYPE;
            ALUSrc      <= `ALUSRC_FOR_ITYPE;
            RegInSelect <= `REGIN_DATABUS;
            PCSrc       <= 0;
            MemWrite    <= 0;
            MemRead     <= 1;
            ALUOp       <= `FUNCTION_OP_ADD;
        end
        `OP_SB: begin
            RegWrite    <= 0;
            SignExtImm  <= 0;
            RegWriteDst <= `REGWRITEDST_FROM_ITYPE;
            ALUSrc      <= `ALUSRC_FOR_ITYPE;
            RegInSelect <= 0;
            PCSrc       <= 0;
            MemWrite    <= 4'b0001 << alu_result[1:0];
            MemRead     <= 0;
            ALUOp       <= `FUNCTION_OP_ADD;
        end
        `OP_SH: begin
            RegWrite    <= 0;
            SignExtImm  <= 0;
            RegWriteDst <= `REGWRITEDST_FROM_ITYPE;
            ALUSrc      <= `ALUSRC_FOR_ITYPE;
            RegInSelect <= 0;
            PCSrc       <= 0;
            MemWrite    <= 4'b0011 << (alu_result[1] << 1);
            MemRead     <= 0;
            ALUOp       <= `FUNCTION_OP_ADD;
        end
        `OP_SW: begin
            RegWrite    <= 0;
            SignExtImm  <= 0;
            RegWriteDst <= `REGWRITEDST_FROM_ITYPE;
            ALUSrc      <= `ALUSRC_FOR_ITYPE;
            RegInSelect <= 0;
            PCSrc       <= 0;
            MemWrite    <= 4'b1111;
            MemRead     <= 0;
            ALUOp       <= `FUNCTION_OP_ADD;
        end
        default: begin // unsupported opcode
            `UNSUPPORTED_OPERATIONS;
        end
    endcase
end
endmodule


module IMMEDIATE_TO_ALU_CONVERTER (
    input wire [`OP_CODE_WIDTH-1:0]         opcode,
    input wire [`FUNCTION_WIDTH-1:0]        instruction_function,
    output reg [`ALU_FUNCTION_WIDTH-1:0]    alu_funct
);

always @(*)
begin
    case (opcode)
        `OP_TYPE_R:  alu_funct <= instruction_function;
        `OP_ADDI:    alu_funct <= `FUNCTION_OP_ADD;
        `OP_ADDIU:   alu_funct <= `FUNCTION_OP_ADD;
        `OP_ANDI:    alu_funct <= `FUNCTION_OP_AND;
        `OP_BEQ:     alu_funct <= `FUNCTION_OP_SUB;
        //`OP_BGEZ:    alu_funct <= `FUNCTION_OP_BGEZ;
        //`OP_BGEZAL:  alu_funct <= `FUNCTION_OP_BGEZAL;
        //`OP_BGTZ:    alu_funct <= `FUNCTION_OP_BGTZ;
        //`OP_BLEZ:    alu_funct <= `FUNCTION_OP_BLEZ;
        //`OP_BLTZ:    alu_funct <= `FUNCTION_OP_BLTZ;
        //`OP_BLTZAL:  alu_funct <= `FUNCTION_OP_BLTZAL;
        //`OP_BNE:     alu_funct <= `FUNCTION_OP_BNE;
        //`OP_JAL:     alu_funct <= `FUNCTION_OP_JAL;
        //`OP_LB:      alu_funct <= `FUNCTION_OP_LB;
        //`OP_LBU:     alu_funct <= `FUNCTION_OP_LBU;
        //`OP_LH:      alu_funct <= `FUNCTION_OP_LH;
        //`OP_LHU:     alu_funct <= `FUNCTION_OP_LHU;
        //`OP_LL:      alu_funct <= `FUNCTION_OP_LL;
        `OP_LUI:     alu_funct <= `PSUEDO_LOAD_UPPER;
        //`OP_LW:      alu_funct <= `FUNCTION_OP_LW;
        `OP_ORI:     alu_funct <= `FUNCTION_OP_OR;
        //`OP_SB:      alu_funct <= `FUNCTION_OPH;
        `OP_SLTI:    alu_funct <= `FUNCTION_OP_SLT;
        //`OP_SLTIU:   alu_funct <= `FUNCTION_OP_SSB;
        //`OP_SH:      alu_funct <= `FUNCTION_OP_SH;
        //`OP_SLTIU:   alu_funct <= `FUNCTION_OP_SLTIU;
        //`OP_SW:      alu_funct <= `FUNCTION_OP_SW;
        `OP_XORI :   alu_funct <= `FUNCTION_OP_XOR;
        default:     alu_funct <= `ALU_FUNCTION_WIDTH'b0;
    endcase
end

endmodule

module ADDER #(parameter WIDTH = 32)
(
	input  wire signed [WIDTH-1:0]	a,
    input  wire signed [WIDTH-1:0]	b,
	output wire signed [WIDTH-1:0]	y
);

assign y = a + b;

endmodule

// register file with one write port and three read ports
// the 3rd read port is for prototyping dianosis
module REGFILE #(
    parameter WIDTH = 32,
    parameter COUNT = 32
)
(
	input wire  clk,
	input wire  [$clog2(COUNT)-1:0] read_address_1,
    input wire  [$clog2(COUNT)-1:0] read_address_2,
    input wire  [$clog2(COUNT)-1:0] write_address,
	input wire  write_enable,
	input wire  [WIDTH-1:0] write_data,
	output wire [WIDTH-1:0] read_data_1,
    output wire [WIDTH-1:0] read_data_2
);

reg		[31:0]	register_file [0:COUNT];

assign read_data_1 = (read_address_1 != 0) ? register_file[read_address_1] : 0;
assign read_data_2 = (read_address_2 != 0) ? register_file[read_address_2] : 0;

//initialize registers to all 0s
integer n;
initial
begin
    for (n=0; n<COUNT; n=n+1)
    begin
        register_file[n] = { (WIDTH) { 1'b0 } };
    end
    //// set stack pointer to position 63
    // register_file[`STACK_POINTER] = 63;
end

//write first order, include logic to handle special case of $0
always @(posedge clk)
begin
    if (write_enable)
    begin
        register_file[write_address] <= write_data;
    end
end

endmodule

module ALU(
    input wire                              clk,
	input wire 	[`REGISTER_WIDTH-1:0]	    a,
    input wire 	[`REGISTER_WIDTH-1:0]       b,
	input wire 	[`ALU_FUNCTION_WIDTH-1:0]   ALUOp,
    input wire  [4:0]                       shift_amount,
	output reg	[`REGISTER_WIDTH-1:0]       result,
	output wire			                    zero,
    output wire			                    less_than_eq,
    output wire			                    greater_than
);

wire signed [`REGISTER_WIDTH-1:0] signed_a;
wire signed [`REGISTER_WIDTH-1:0] signed_b;

assign signed_a = a;
assign signed_b = b;

assign zero         = (result == 32'b0);
assign less_than_eq = (signed_a <= 0);
assign greater_than = (signed_a > 0);

reg	[`REGISTER_WIDTH-1:0] high_result;
reg	[`REGISTER_WIDTH-1:0]  low_result;

always @(*)
begin
    case(ALUOp)
        `FUNCTION_OP_ADD:       result <=  (signed_a + signed_b);
        `FUNCTION_OP_ADDU:      result <=  (a + b);
        `FUNCTION_OP_AND:       result <=  (a & b);
        `FUNCTION_OP_CLO:       result <= `REGISTER_WIDTH'hxxxxxxxx; // count leading ones
        `FUNCTION_OP_CLZ:       result <= `REGISTER_WIDTH'hxxxxxxxx; // count leading zeros
        `FUNCTION_OP_JALR:      result <=  a;
        `FUNCTION_OP_JR:        result <=  a;
        `FUNCTION_OP_MFHI:      result <=  high_result;
        `FUNCTION_OP_MFLO:      result <=  low_result;
        `FUNCTION_OP_NOR:       result <= ~(a | b);
        `FUNCTION_OP_OR:        result <=  (a | b);
        `FUNCTION_OP_SLL:       result <=  (b << shift_amount);
        `FUNCTION_OP_SLLV:      result <=  (a << b);
        `FUNCTION_OP_SLT:       result <=  (signed_a < signed_b) ? 32'b1 : 32'b0;
        `FUNCTION_OP_SLTU:      result <=  (a < b) ? 32'b1 : 32'b0;
        `FUNCTION_OP_SRA:       result <=  (b >>> shift_amount);
        `FUNCTION_OP_SRAV:      result <=  (a >>> b);
        `FUNCTION_OP_SRL:       result <=  (b >> shift_amount);
        `FUNCTION_OP_SRLV:      result <=  (a >> b);
        `FUNCTION_OP_SUB:       result <=  (signed_a - signed_b);
        `FUNCTION_OP_SUBU:      result <=  (a - b);
        `FUNCTION_OP_XOR:       result <=  (a ^ b);
        `PSUEDO_LOAD_UPPER:     result <= (b << `REGISTER_WIDTH/2);
        default:                result <= `REGISTER_WIDTH'hxxxxxxxx;
        /* NOTE:
            The clk signal is used here only to qualify the period before an instruction
            transition. Without this qualification, during transition, the high_result and
            low_result registers are re-written with contents of the next instruction
            destroying the results of the previous instruction.
        */
        `FUNCTION_OP_MULT, `FUNCTION_OP_MULTU:
        begin
            if(!clk)
            begin
                { high_result, low_result } = (signed_a * signed_b);
                result <= 0;
            end
        end
        `FUNCTION_OP_DIV, `FUNCTION_OP_DIVU:
        begin
            if(!clk)
            begin
                high_result = (signed_a % signed_b);
                low_result  = (signed_a / signed_b);
                result <= 0;
            end
        end
    endcase
end

endmodule

module VALUE_EXTEND #(
    parameter INPUT_WIDTH = 16,
    parameter OUTPUT_WIDTH = 32
)
(
    input  wire                     sign_extend,
	input  wire [INPUT_WIDTH-1:0]   a,
	output wire [OUTPUT_WIDTH-1:0]  y
);

wire [OUTPUT_WIDTH-1:0] sign_extended_value = { { (OUTPUT_WIDTH-INPUT_WIDTH){ a[INPUT_WIDTH-1] } }, a };
wire [OUTPUT_WIDTH-1:0] zero_extended_value = { { (OUTPUT_WIDTH-INPUT_WIDTH){ 1'b0 } }, a };

assign y = (sign_extend) ? sign_extended_value : zero_extended_value;

endmodule

module SHIFT_LEFT #(parameter AMOUNT = 2)
(
	input wire [`REGISTER_WIDTH-1:0]	a,
	output wire	[`REGISTER_WIDTH-1:0]	y
);

assign y = (a << AMOUNT);

endmodule

module SHIFT_RIGHT #(parameter WIDTH = 32)
(
	input wire  [WIDTH-1:0]	a,
    input wire  [WIDTH-1:0] b,
	output wire	[WIDTH-1:0]	y
);

assign y = (a >> b);

endmodule

module MULT #(parameter WIDTH = 32)(
    input wire              sign,
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    output wire [(WIDTH*2)-1:0] out
);

wire [WIDTH-1:0] signed_a = a;
wire [WIDTH-1:0] signed_b = b;

wire [(WIDTH*2)-1:0] signed_product   = signed_a * signed_b;
wire [(WIDTH*2)-1:0] unsigned_product =        a * b;

assign out = (sign) ? signed_product : unsigned_product;

endmodule

module DIV #(parameter WIDTH = 32)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    output wire [WIDTH-1:0] quotient,
    output wire [WIDTH-1:0] modulus
);

assign quotient = a / b;
assign modulus  = a % b;

endmodule
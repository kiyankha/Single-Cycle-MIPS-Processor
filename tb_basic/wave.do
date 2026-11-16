#==============================================================================
# wave.do - waveform setup for the ACA-MIPS single-cycle processor
#
# Usage (ModelSim, after cd to the tb_basic directory):
#
#   do compile.do
#   vsim -voptargs=+acc work.single_cycle_mips__tb_basic
#   do wave.do
#   run 45 ns          ; reset released, first instruction finished
#   run 10 ns          ; one instruction per clock (clock period is 10 ns)
#
# "+acc" is important: it stops vopt from hiding internal (non-port) signals.
#
# The isort testbench has its own copy at tb_isort/wave.do.
#==============================================================================

onerror {resume}
quietly WaveActivateNextPane {} 0

set TB /single_cycle_mips__tb_basic

#------------------------------------------------------------------ clock/reset
add wave -noupdate -divider {Clock and reset}
add wave -noupdate -color Orange $TB/clk
add wave -noupdate -color Orange $TB/reset

#------------------------------------------------------------------ 1. fetch
add wave -noupdate -divider {1. Fetch}
add wave -noupdate -radix hex -color Cyan $TB/cpu/PC
add wave -noupdate -radix hex $TB/cpu/PC_plus4
add wave -noupdate -radix hex $TB/cpu/instr

#------------------------------------------------------------------ 2. decode
add wave -noupdate -divider {2. Decode}
add wave -noupdate -radix hex $TB/cpu/opcode
add wave -noupdate -radix unsigned $TB/cpu/rs
add wave -noupdate -radix unsigned $TB/cpu/rt
add wave -noupdate -radix unsigned $TB/cpu/rd
add wave -noupdate -radix unsigned $TB/cpu/shamt
add wave -noupdate -radix hex $TB/cpu/funct
add wave -noupdate -radix hex $TB/cpu/imm16
add wave -noupdate -radix hex $TB/cpu/imm32

#------------------------------------------------------------------ 3. control
add wave -noupdate -divider {3. Control}
add wave -noupdate -radix binary $TB/cpu/ALUControl
add wave -noupdate $TB/cpu/RegDst
add wave -noupdate $TB/cpu/ALUSrc
add wave -noupdate $TB/cpu/MemtoReg
add wave -noupdate $TB/cpu/RegWrite
add wave -noupdate $TB/cpu/MemWrite
add wave -noupdate $TB/cpu/Branch
add wave -noupdate $TB/cpu/is_branch
# PCSrc is declared in the design but never driven high (is_branch is used
# instead); it is left out on purpose.

#------------------------------------------------------------------ 4. datapath
add wave -noupdate -divider {4. Datapath}
add wave -noupdate -radix hex $TB/cpu/SrcA
add wave -noupdate -radix hex $TB/cpu/RegFile_RD2
add wave -noupdate -radix hex $TB/cpu/SrcB
add wave -noupdate -radix hex $TB/cpu/ALUResult
add wave -noupdate $TB/cpu/Zero
add wave -noupdate -radix hex $TB/cpu/PCBranch
add wave -noupdate -radix unsigned $TB/cpu/WriteReg_5b

#------------------------------------------------------------------ 5. writeback
add wave -noupdate -divider {5. Writeback}
add wave -noupdate -radix hex $TB/cpu/Result
add wave -noupdate -radix hex $TB/cpu/ReadData

#------------------------------------------------------------------ ALU internals
add wave -noupdate -divider {ALU internals}
add wave -noupdate -radix hex $TB/cpu/main_alu/sum
add wave -noupdate $TB/cpu/main_alu/v
add wave -noupdate $TB/cpu/main_alu/slt
add wave -noupdate $TB/cpu/main_alu/sltu

#------------------------------------------------------------------ storage
add wave -noupdate -divider {Register file}
add wave -noupdate -radix hex $TB/cpu/rf/reg_data

add wave -noupdate -divider {Data memory (click + to expand)}
add wave -noupdate -radix hex $TB/cpu/dmem/mem_data

#------------------------------------------------------------------ formatting
configure wave -namecolwidth 220
configure wave -valuecolwidth 110
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns

WaveRestoreZoom {0 ns} {120 ns}
update

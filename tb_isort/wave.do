#==============================================================================
# wave.do - waveform setup for the ACA-MIPS single-cycle processor (isort)
#
# Usage (ModelSim, after cd to the tb_isort directory):
#
#   do compile.do
#   vsim -voptargs=+acc work.single_cycle_mips__tb_isort
#   do wave.do
#
# Or simply:
#
#   do run_wave.do
#
# "+acc" is important: it stops vopt from hiding internal (non-port) signals.
#==============================================================================

onerror {resume}
quietly WaveActivateNextPane {} 0

set TB /single_cycle_mips__tb_isort

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

# Registers the isort program actually uses, expanded for convenience
add wave -noupdate -divider {Sort registers}
add wave -noupdate -radix hex -label {$v0} $TB/cpu/rf/reg_data(2)
add wave -noupdate -radix hex -label {$v1} $TB/cpu/rf/reg_data(3)
add wave -noupdate -radix hex -label {$t0} $TB/cpu/rf/reg_data(8)
add wave -noupdate -radix hex -label {$t1} $TB/cpu/rf/reg_data(9)
add wave -noupdate -radix hex -label {$t2} $TB/cpu/rf/reg_data(10)
add wave -noupdate -radix hex -label {$t3} $TB/cpu/rf/reg_data(11)
add wave -noupdate -radix hex -label {$t4} $TB/cpu/rf/reg_data(12)
add wave -noupdate -radix hex -label {$t5} $TB/cpu/rf/reg_data(13)
add wave -noupdate -radix hex -label {$t6} $TB/cpu/rf/reg_data(14)

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

WaveRestoreZoom {0 ns} {1000 ns}
update

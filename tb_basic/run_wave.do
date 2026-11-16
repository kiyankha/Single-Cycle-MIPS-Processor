#==============================================================================
# run_wave.do - compile, load, and open the waveform window for tb_basic
#
# Usage (ModelSim, after cd to the tb_basic directory):
#
#   do run_wave.do
#
# Then advance one instruction at a time with:
#
#   run 10 ns
#
# or press the "Run 10ns" button. Use "restart -f; run 45 ns" to start over.
#==============================================================================

do compile.do

# +acc keeps internal signals visible in the wave window
vsim -voptargs=+acc work.single_cycle_mips__tb_basic

do wave.do

# Reset is released at t=31 ns; the instruction at PC=0x00 completes at t=40 ns,
# so this leaves PC=0x04 and the first instruction's result in the registers.
run 45 ns

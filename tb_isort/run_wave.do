#==============================================================================
# run_wave.do - compile, load, and open the waveform window for tb_isort
#
# Usage (ModelSim, after cd to the tb_isort directory):
#
#   do run_wave.do
#
# The first 96 iterations fill memory, so the simulation stops when PC reaches
# the sort routine at 0x28. From there:
#
#   run 10 ns          ; one instruction per clock (clock period is 10 ns)
#   run -all           ; finish the whole sort
#==============================================================================

do compile.do

# +acc keeps internal signals visible in the wave window
vsim -voptargs=+acc work.single_cycle_mips__tb_isort

do wave.do

# Start of sort: addi $t0, $zero, 4 at PC=0x28
when {/single_cycle_mips__tb_isort/cpu/PC = 32'h28} {stop}
run -all

# Put the current time (sort entry) in view
WaveRestoreZoom {6700 ns} {6900 ns}

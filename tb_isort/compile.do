transcript on

# Run this file from the tb_isort directory (in ModelSim, cd there first).
# The design lives one level up, at the project root, so there is only one copy.
puts "Working directory: [pwd]"

if {[file exists work]} {
    vdel -lib work -all
}
vlib work
vmap work work

vlog -work work \
    ../building_blocks.v \
    ../single_cycle_mips.v \
    single_cycle_mips__tb_isort.v

puts "COMPILE OK"

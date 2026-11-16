# ACA-MIPS Single-Cycle Processor

Single-cycle implementation of the ACA-MIPS ISA in Verilog for ModelSim SE
(course project for Advanced Computer Architecture).

## Implemented instructions

- R-type: `add`, `addu`, `sub`, `subu`, `and`, `or`, `xor`, `nor`, `slt`, `sltu`
- I-type: `addi`, `addiu`, `slti`, `sltiu`, `andi`, `ori`, `xori`, `lui`, `beq`, `bne`, `lw`, `sw`

## Project layout

| Path | Description |
| --- | --- |
| `single_cycle_mips.v` | The design: datapath, control unit, program counter, ALU |
| `building_blocks.v` | Provided `async_mem` and `reg_file` blocks |
| `tb_basic/` | Smoke test; prints 21 memory words at the end |
| `tb_isort/` | Insertion-sort test; checks sorting and expected values |
| `Single Cycle MIPS.pdf` | Assignment description |

The design exists only at the project root. Each testbench's `compile.do` compiles
`../building_blocks.v` and `../single_cycle_mips.v`, so there is a single copy to edit.
Run the `.do` files from inside their testbench folder.

## Running the tests (ModelSim command line)

Run each test from its own folder. One ModelSim session compiles, loads, and runs:

```powershell
cd tb_basic
vsim -c -wlf none -do "do compile.do; vsim work.single_cycle_mips__tb_basic; run -all; quit -f"

cd ..\tb_isort
vsim -c -wlf none -do "do compile.do; vsim work.single_cycle_mips__tb_isort; run -all; quit -f"
```

## Debugging with waveforms

`tb_basic` is a straight-line program, so it is the best test for watching individual
instructions. From the `tb_basic` directory:

```powershell
do run_wave.do
```

This compiles, loads with `-voptargs=+acc` (keeps internal signals visible), applies
`tb_basic/wave.do`, and runs to 45 ns. Then `run 10 ns` advances exactly one
instruction, since the clock period is 10 ns. Reset is released at 31 ns and the
instruction at PC=0 completes at 40 ns.

- Restart: `restart -f; run 45 ns`
- Stop at a given instruction:
  `when {/single_cycle_mips__tb_basic/cpu/PC == 32'h2C} {stop}` then `run -all`

For the isort test, from the `tb_isort` directory:

```powershell
do run_wave.do
```

It stops when PC reaches `0x28` (the first instruction of the sort routine), after
the 96-iteration fill loop. `tb_isort/wave.do` adds the sort registers (`$v0`, `$v1`,
`$t0`-`$t6`) individually for easier reading. From there use `run 10 ns` to step through
the sort or `run -all` to finish and see the PASS messages.

## Status

- `tb_basic`: output matches the expected values in the assignment.
- `tb_isort`: `PASS1, All Sorted!` and `Pass2, Output Matches the expected Numbers!`,
  finished at 258,351 ns (limit 258,400 ns).

## Notes

- Branch instructions (`beq`, `bne`) no longer assert `RegWrite`, so they cannot write
  an undefined value into the register file after synthesis.
- Local handout/backup archives (`*.zip`) and ModelSim output (`work/`, `transcript`,
  `modelsim.ini`, `*.wlf`) are ignored by git and stay on the local machine only.

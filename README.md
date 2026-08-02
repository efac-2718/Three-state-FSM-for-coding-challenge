# RISC-V CFI Landing-Pad FSM

A 3-state SystemVerilog FSM modelling the
forward-edge control-flow-integrity check of the RISC-V Zicfilp
extension. Submission for the LFX mentorship coding challenge.

## Zicfilp correspondence

| This design            | Zicfilp                                    |
|------------------------|--------------------------------------------|
| SET stores label       | establishing expected label (x7 / t2)      |
| JUMP → CHECK           | indirect jump sets ELP = LP_EXPECTED       |
| LPAD + match → IDLE    | landing pad with matching label clears ELP |
| mismatch → ERROR       | software-check exception (landing pad fault)|

real ELP is a 2-value flag,
real fault is an exception not a trap state.

## Design
<img src="https://raw.githubusercontent.com/efac-2718/FrontEnd/refs/heads/master/design.jpeg" alt="design" width="400">

- **(At ERROR state external reset is required)**
- An error_o output was added to indicate that the program is in error state
## Known limitations and open questions

- A landing pad can reach even before the machine goes into CHECK state, no check for that is performed here.
- In the CHECK state the program expects the LPAD command on the very next cycle. If it doesn't receive it the state goes into ERROR state.

## Verification

- Self-checking testbench: golden reference model, 12 directed
  phases, constrained-random stimulus, SVA assertions
  (error stickiness, label write conditions).
- Lint-clean under Verilator (-Wall).
- Simulated with VCS (via EDA Playground)

## Running

    # Lint the design
    verilator --lint-only -Wall cfi.sv

    # Simulate in ModelSim-Altera
    vlog -sv cfi.sv Testbench/*.sv
    vsim -c work.cfi_tb -do "run -all; quit"

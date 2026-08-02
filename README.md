# RISC-V CFI Landing-Pad FSM

One-sentence summary: a 3-state SystemVerilog FSM modelling the
forward-edge control-flow-integrity check of the RISC-V Zicfilp
extension. Submission for the LFX mentorship coding challenge.

## Zicfilp correspondence

| This design            | Zicfilp                                    |
|------------------------|--------------------------------------------|
| SET stores label       | establishing expected label (x7 / t2)      |
| JUMP → CHECK           | indirect jump sets ELP = LP_EXPECTED       |
| LPAD + match → IDLE    | landing pad with matching label clears ELP |
| mismatch → ERROR       | software-check exception (landing pad fault)|

Two sentences max on the simplifications: real ELP is a 2-value flag,
real fault is an exception not a trap state.

## Design decisions

- **Registered (Moore) error output** — one line on the latency
  tradeoff and why you chose it.
- **Fail-closed default** — unreachable state encodings trap to ERROR;
  one line on why that's the right instinct for a security block.
- **ERROR requires external reset** — deliberate, not a bug; one line.
- **Label write lives in the clocked block** — one line (latch avoidance).

## Known limitations / open questions

- Stray LPAD in IDLE is silently ignored — note the threat-model
  question you flagged.
- CHECK expects LPAD on the immediately following cycle (no NOP
  tolerance) — note the pipeline-realism question.

## Verification

- Self-checking testbench: golden reference model, 12 directed
  phases, constrained-random stimulus, SVA assertions
  (error stickiness, label write conditions).
- Lint-clean under Verilator (-Wall).

## Running

    iverilog -g2012 -o sim cfi.sv cfi_tb.sv && ./sim
    verilator --lint-only -Wall cfi.sv

## Synthesis (Altera MAX II EPM240T100C5)

X / 240 LEs, fmax Y MHz (Quartus II 13.0sp1).
cfi_demo.sv is a hardware bring-up wrapper (ROM sequencer + clock
divider + LEDs); the deliverable is cfi.sv + cfi_tb.sv.

## Files
one line each.

# Contributing

Small RTL and verification improvements are welcome.

## Prerequisites and tests

Install Icarus Verilog (`iverilog`, `vvp`) and Python 3.10+, then run:

```powershell
python scripts\run_tests.py
```

## Change expectations

- Keep synthesizable RTL separate from testbench stimulus.
- Add a self-checking testbench for each new module or behavior.
- State reset polarity/timing, parameter constraints, and flag semantics in module comments or the README.
- Inspect VCD output for relevant state/timing changes; do not commit generated `build/` output.
- Do not claim synthesis, timing closure, or physical FPGA testing unless those steps were actually performed.

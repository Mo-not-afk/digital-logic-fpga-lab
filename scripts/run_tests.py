"""Compile and run all self-checking Verilog benches with Icarus Verilog."""

from __future__ import annotations

import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CASES = {
    "tb_combinational": ["rtl/logic_gates.v", "tb/tb_combinational.v"],
    "tb_alu": ["rtl/alu.v", "tb/tb_alu.v"],
    "tb_counter": ["rtl/counter.v", "tb/tb_counter.v"],
    "tb_sequence_detector": ["rtl/sequence_detector.v", "tb/tb_sequence_detector.v"],
    "tb_register_file": ["rtl/register_file.v", "tb/tb_register_file.v"],
}


def main() -> int:
    compiler = shutil.which("iverilog")
    runtime = shutil.which("vvp")
    if not compiler or not runtime:
        print("Icarus Verilog is required. Install iverilog/vvp, then rerun this script.", file=sys.stderr)
        return 2

    build = ROOT / "build"
    build.mkdir(exist_ok=True)
    for top, sources in CASES.items():
        executable = build / f"{top}.vvp"
        compile_command = [compiler, "-g2012", "-Wall", "-s", top, "-o", str(executable), *sources]
        print(f"[compile] {top}")
        try:
            subprocess.run(compile_command, cwd=ROOT, check=True)
            subprocess.run([runtime, str(executable)], cwd=ROOT, check=True)
        except subprocess.CalledProcessError as error:
            print(f"FAILED: {top} (exit {error.returncode})", file=sys.stderr)
            return error.returncode or 1
    print(f"PASS: {len(CASES)} Verilog testbenches")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

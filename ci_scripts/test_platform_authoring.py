#!/usr/bin/env python3
"""Build and run the platform-authoring hosts on macOS, Linux, or Windows."""

import argparse
import os
from pathlib import Path
import platform
import subprocess
import tempfile

EXAMPLE = Path(__file__).resolve().parents[1] / "examples" / "PlatformAuthoring"


def run(*command):
    print("+", " ".join(map(str, command)), flush=True)
    subprocess.run(list(map(str, command)), cwd=EXAMPLE, check=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--roc", default=os.environ.get("ROC", "roc"))
    parser.add_argument("--host", choices=["c", "zig", "rust", "all"], default="all")
    args = parser.parse_args()
    windows = platform.system() == "Windows"
    # Match Zig's ABI to the MSVC archive produced by Roc's Windows targets.
    zig_target = []
    if windows:
        arch = "aarch64" if platform.machine().lower() in ("arm64", "aarch64") else "x86_64"
        zig_target = ["-target", f"{arch}-windows-msvc"]

    run(args.roc, "test", "--no-cache", "main.roc")
    with tempfile.TemporaryDirectory(prefix="roc-platform-authoring-") as work:
        work = Path(work)
        archive = work / ("app.lib" if windows else "app.a")
        run(args.roc, "build", "--no-cache", "main.roc", f"--output={archive}")
        hosts = ["c", "zig", "rust"] if args.host == "all" else [args.host]
        for host in hosts:
            binary = work / (f"host-{host}.exe" if windows else f"host-{host}")
            if host == "c":
                if windows:
                    run("cl", "/nologo", "/std:c11", "host.c", archive,
                        f"/Fo{work / 'host.obj'}", f"/Fe{binary}")
                else:
                    run("cc", "-std=c11", "host.c", archive, "-lm", "-o", binary)
            elif host == "zig":
                run("zig", "build-exe", "host.zig", archive, "-lc", *zig_target,
                    f"-femit-bin={binary}")
            else:
                run("rustc", "--edition=2024", "host.rs", "-C", f"link-arg={archive}",
                    "-o", binary)
            result = subprocess.run([str(binary)], cwd=EXAMPLE, check=True,
                                    capture_output=True, text=True)
            if result.stdout != "42\n":
                raise RuntimeError(f"{host}: expected '42', got {result.stdout!r}")
            print(f"{host}: printed 42 and exited successfully", flush=True)


if __name__ == "__main__":
    main()

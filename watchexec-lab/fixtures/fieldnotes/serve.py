#!/usr/bin/env python3
"""A tiny fixture server for the watchexec lab.

Reads banner.txt once, at startup, and serves that text plus
its own process ID. Because the banner is read only at
startup, the page can only change when the server restarts --
which is exactly what the restart experiment needs.

On SIGTERM it leaves a note in ../signals.log before exiting,
so the lab can prove which signal stopped it.
"""
import os
import signal
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer

HERE = os.path.dirname(os.path.abspath(__file__))
PID = os.getpid()

with open(os.path.join(HERE, "banner.txt"), encoding="utf-8") as fh:
    BANNER = fh.read().strip()


def on_sigterm(signum, frame):
    log = os.path.join(HERE, "..", "signals.log")
    with open(log, "a", encoding="utf-8") as fh:
        fh.write(f"server pid {PID} received SIGTERM and exited cleanly\n")
    sys.exit(0)


signal.signal(signal.SIGTERM, on_sigterm)


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        body = f"banner: {BANNER}\nserved by pid: {PID}\n".encode()
        self.send_response(200)
        self.send_header("Content-Type", "text/plain")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *args):
        pass


print(f"server starting, pid {PID}, banner: {BANNER}", flush=True)
HTTPServer(("127.0.0.1", 18093), Handler).serve_forever()

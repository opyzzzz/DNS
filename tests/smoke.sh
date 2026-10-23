#!/bin/sh
# Static smoke checks; safe to run without root or a live SmartDNS daemon.
set -eu
ROOT=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
sh -n "$ROOT/sdns.sh"
sh -n "$ROOT/lib/common.sh"
sh -n "$ROOT/lib/dns.sh"
grep -q 'Test in an isolated foreground process' "$ROOT/sdns.sh"
! grep -A8 '^test_config_safe()' "$ROOT/sdns.sh" | grep -q 'pkill -x smartdns'
grep -q '不支持的 CPU 架构' "$ROOT/sdns.sh"
grep -q 'restore_resolv_conf' "$ROOT/sdns.sh"
printf '%s\n' 'smoke checks passed'

# sdns modularization notes

This is an incremental POSIX-shell-oriented refactor. The existing Chinese menu and
`sdns` command interface remain in `sdns.sh`; shared helpers and resolver state
handling are extracted into `lib/`.

## Modules

- `lib/common.sh`: logging, BusyBox detection, and explicit CPU architecture mapping.
- `lib/dns.sh`: records whether `/etc/resolv.conf` was a regular file, a symlink,
  or absent, and restores that state during uninstall.
- `tests/smoke.sh`: shell syntax and static safety checks.

## Safety changes in this increment

- The configuration smoke test no longer kills every process named `smartdns`.
- Unknown CPU architectures fail closed instead of downloading an x86_64 binary.
- OS detection rejects unknown distributions instead of assuming every non-Alpine
  system uses Debian/apt.
- If UDP/53 remains occupied, configuration aborts instead of selecting 5353/5354
  while still directing the system resolver to 127.0.0.1:53.
- Resolver backup metadata preserves symlink targets for uninstall recovery.

## Remaining work

The existing installer still has legacy non-POSIX extensions (notably `local` and
external utilities whose availability varies by platform). DNS takeover currently
installs a periodic resolver guard and changes several host network files; those
changes need a complete manifest-based rollback before takeover can be considered
fully transactional. Binary signature/checksum verification and atomic upgrade
rollback also remain follow-up work. Run the smoke test on each supported shell and
exercise install/upgrade/uninstall in disposable Debian and Alpine VMs before use
on production hosts.

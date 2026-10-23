# Shared helpers for sdns.sh. Keep this file compatible with /bin/sh.
log_info()  { printf "%b[INFO]%b %s\n" "$CYAN" "$NC" "$1"; }
log_ok()    { printf "%b[OK]%b %s\n" "$GREEN" "$NC" "$1"; }
log_err()   { printf "%b[ERROR]%b %s\n" "$RED" "$NC" "$1"; }
log_warn()  { printf "%b[WARN]%b %s\n" "$YELLOW" "$NC" "$1"; }
log_step()  { printf "\n%b>>> %s%b\n" "$BOLD$BLUE" "$1" "$NC"; }

detect_busybox() {
    command -v busybox >/dev/null 2>&1 && BB="busybox"
}

# Return failure for unknown architectures: never silently install an x86_64 binary.
get_arch() {
    case "$(uname -m)" in
        x86_64|amd64) printf '%s\n' x86_64 ;;
        aarch64|arm64) printf '%s\n' aarch64 ;;
        armv7l|armv7) printf '%s\n' arm ;;
        i386|i686) printf '%s\n' x86 ;;
        *) return 1 ;;
    esac
}

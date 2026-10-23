# DNS state helpers. The content backup alone cannot restore a resolv.conf symlink.
RESOLV_ORIG="/etc/resolv.conf.smartdns.orig"
RESOLV_ORIG_TYPE="/etc/resolv.conf.smartdns.orig.type"
RESOLV_ORIG_TARGET="/etc/resolv.conf.smartdns.orig.target"

backup_resolv_conf() {
    [ -e "$RESOLV_ORIG_TYPE" ] && return 0
    if [ -L /etc/resolv.conf ]; then
        readlink /etc/resolv.conf > "$RESOLV_ORIG_TARGET" || return 1
        printf '%s\n' symlink > "$RESOLV_ORIG_TYPE" || return 1
        cat /etc/resolv.conf > "$RESOLV_ORIG" 2>/dev/null || :
    elif [ -e /etc/resolv.conf ]; then
        cp -p /etc/resolv.conf "$RESOLV_ORIG" || return 1
        printf '%s\n' file > "$RESOLV_ORIG_TYPE" || return 1
    else
        printf '%s\n' absent > "$RESOLV_ORIG_TYPE" || return 1
    fi
}

restore_resolv_conf() {
    [ -f "$RESOLV_ORIG_TYPE" ] || return 1
    case "$(cat "$RESOLV_ORIG_TYPE")" in
        symlink)
            [ -s "$RESOLV_ORIG_TARGET" ] || return 1
            rm -f /etc/resolv.conf || return 1
            ln -s "$(cat "$RESOLV_ORIG_TARGET")" /etc/resolv.conf || return 1
            ;;
        file)
            [ -f "$RESOLV_ORIG" ] || return 1
            rm -f /etc/resolv.conf || return 1
            cp -p "$RESOLV_ORIG" /etc/resolv.conf || return 1
            ;;
        absent) rm -f /etc/resolv.conf || return 1 ;;
        *) return 1 ;;
    esac
    rm -f "$RESOLV_ORIG" "$RESOLV_ORIG_TYPE" "$RESOLV_ORIG_TARGET"
}

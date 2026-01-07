#!/usr/bin/env bash
#
# motd.sh - Custom Message of the Day
# VPS Dotfiles - Cross-platform support
#

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'

# Get system info (cross-platform)
get_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$PRETTY_NAME"
    elif [ -f /etc/redhat-release ]; then
        cat /etc/redhat-release
    elif [ "$(uname)" = "Darwin" ]; then
        echo "macOS $(sw_vers -productVersion)"
    else
        uname -s
    fi
}

get_kernel() {
    uname -r
}

get_uptime() {
    if command -v uptime &>/dev/null; then
        uptime -p 2>/dev/null | sed 's/up //' || uptime | awk -F'( |,|:)+' '{print $6"h "$7"m"}'
    fi
}

get_shell() {
    basename "$SHELL"
}

get_memory() {
    if [ -f /proc/meminfo ]; then
        local total=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
        local avail=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
        local used=$((total - avail))
        printf "%.1f GiB / %.1f GiB" "$((used / 1024))e-3" "$((total / 1024))e-3"
    elif command -v vm_stat &>/dev/null; then
        # macOS
        echo "N/A"
    fi
}

get_memory_simple() {
    if [ -f /proc/meminfo ]; then
        local total=$(awk '/MemTotal/ {printf "%.1f", $2/1024/1024}' /proc/meminfo)
        local avail=$(awk '/MemAvailable/ {printf "%.1f", $2/1024/1024}' /proc/meminfo)
        local used=$(awk -v t="$total" -v a="$avail" 'BEGIN {printf "%.1f", t-a}')
        echo "${used} / ${total} GiB"
    fi
}

get_packages() {
    local count=0
    local mgr=""
    
    if command -v dpkg &>/dev/null; then
        count=$(dpkg -l 2>/dev/null | grep -c '^ii')
        mgr="dpkg"
    elif command -v rpm &>/dev/null; then
        count=$(rpm -qa 2>/dev/null | wc -l)
        mgr="rpm"
    elif command -v pacman &>/dev/null; then
        count=$(pacman -Q 2>/dev/null | wc -l)
        mgr="pacman"
    elif command -v apk &>/dev/null; then
        count=$(apk list --installed 2>/dev/null | wc -l)
        mgr="apk"
    fi
    
    [ -n "$mgr" ] && echo "$count ($mgr)" || echo "N/A"
}

get_hostname() {
    hostname 2>/dev/null || cat /etc/hostname 2>/dev/null || echo "unknown"
}

get_user() {
    whoami
}

get_distro_short() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}'
    else
        uname -s
    fi
}

# Print MOTD
print_motd() {
    local user=$(get_user)
    local host=$(get_hostname)
    local os=$(get_os)
    local kernel=$(get_kernel)
    local uptime=$(get_uptime)
    local shell=$(get_shell)
    local mem=$(get_memory_simple)
    local pkgs=$(get_packages)
    local distro=$(get_distro_short)

    echo ""
    echo -e "${GRAY}┌──────────────────────────────────────────────────────┐${NC}"
    echo -e "${GRAY}│${NC}                                                      ${GRAY}│${NC}"
    echo -e "${GRAY}│${NC}  ${CYAN}󰒋 kernel${NC}      ${WHITE}${kernel}${NC}"
    echo -e "${GRAY}│${NC}  ${CYAN}󰔚 uptime${NC}      ${WHITE}${uptime}${NC}"
    echo -e "${GRAY}│${NC}  ${CYAN}󰆍 shell${NC}       ${WHITE}${shell}${NC}"
    echo -e "${GRAY}│${NC}  ${CYAN}󰍛 mem${NC}         ${WHITE}${mem}${NC}"
    echo -e "${GRAY}│${NC}  ${CYAN}󰏖 pkgs${NC}        ${WHITE}${pkgs}${NC}"
    echo -e "${GRAY}│${NC}  ${CYAN} user${NC}        ${WHITE}${user}${NC}"
    echo -e "${GRAY}│${NC}  ${CYAN}󰒍 hname${NC}       ${WHITE}${host}${NC}"
    echo -e "${GRAY}│${NC}  ${CYAN} distro${NC}      ${WHITE}${distro}${NC}"
    echo -e "${GRAY}│${NC}                                                      ${GRAY}│${NC}"
    echo -e "${GRAY}└──────────────────────────────────────────────────────┘${NC}"
    echo ""
}

print_motd

#!/bin/bash

# system_monitor.sh - Basic system health monitoring

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

# Function to check CPU usage
check_cpu() {
    print_header "CPU USAGE"
    
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    echo -e "CPU Usage: ${cpu_usage}%"
    
    if (( $(echo "$cpu_usage > 80" | bc -l) )); then
        echo -e "${RED}WARNING: High CPU usage detected!${NC}"
    elif (( $(echo "$cpu_usage > 60" | bc -l) )); then
        echo -e "${YELLOW}CAUTION: Moderate CPU usage${NC}"
    else
        echo -e "${GREEN}CPU usage is normal${NC}"
    fi
    
    # Show top 5 CPU consuming processes
    echo -e "\nTop 5 CPU consuming processes:"
    ps aux --sort=-%cpu | head -6 | tail -5
}

# Function to check memory usage
check_memory() {
    print_header "MEMORY USAGE"
    
    mem_info=$(free -h | grep Mem)
    total=$(echo $mem_info | awk '{print $2}')
    used=$(echo $mem_info | awk '{print $3}')
    free=$(echo $mem_info | awk '{print $4}')
    
    mem_percentage=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100)}')
    
    echo -e "Total Memory: $total"
    echo -e "Used Memory: $used"
    echo -e "Free Memory: $free"
    echo -e "Memory Usage: ${mem_percentage}%"
    
    if [ "$mem_percentage" -gt 90 ]; then
        echo -e "${RED}WARNING: Critical memory usage!${NC}"
    elif [ "$mem_percentage" -gt 75 ]; then
        echo -e "${YELLOW}CAUTION: High memory usage${NC}"
    else
        echo -e "${GREEN}Memory usage is normal${NC}"
    fi
    
    # Show top 5 memory consuming processes
    echo -e "\nTop 5 memory consuming processes:"
    ps aux --sort=-%mem | head -6 | tail -5
}

# Function to check disk usage
check_disk() {
    print_header "DISK USAGE"
    
    df -h | grep -E '^/dev/' | while read line; do
        usage=$(echo $line | awk '{print $5}' | cut -d'%' -f1)
        partition=$(echo $line | awk '{print $1}')
        mount=$(echo $line | awk '{print $6}')
        
        echo -e "\nPartition: $partition (mounted on $mount)"
        echo $line | awk '{print "Total: "$2" | Used: "$3" | Available: "$4" | Usage: "$5}'
        
        if [ "$usage" -gt 90 ]; then
            echo -e "${RED}WARNING: Critical disk space!${NC}"
        elif [ "$usage" -gt 75 ]; then
            echo -e "${YELLOW}CAUTION: Low disk space${NC}"
        else
            echo -e "${GREEN}Disk space is adequate${NC}"
        fi
    done
}

# Function to check system load
check_load() {
    print_header "SYSTEM LOAD"
    
    load=$(uptime | awk -F'load average:' '{print $2}')
    cores=$(nproc)
    
    echo -e "CPU Cores: $cores"
    echo -e "Load Average:$load"
    
    load_1min=$(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | xargs)
    
    if (( $(echo "$load_1min > $cores" | bc -l) )); then
        echo -e "${RED}WARNING: System load exceeds CPU cores!${NC}"
    else
        echo -e "${GREEN}System load is normal${NC}"
    fi
}

# Function to check uptime
check_uptime() {
    print_header "SYSTEM UPTIME"
    
    uptime_info=$(uptime -p)
    boot_time=$(who -b | awk '{print $3, $4}')
    
    echo -e "System Uptime: $uptime_info"
    echo -e "Last Boot: $boot_time"
}

# Function to check network
check_network() {
    print_header "NETWORK INFORMATION"
    
    # Get primary network interface
    interface=$(ip route | grep default | awk '{print $5}' | head -1)
    
    if [ -n "$interface" ]; then
        echo -e "Primary Interface: $interface"
        
        # Get IP address
        ip_addr=$(ip addr show $interface | grep "inet " | awk '{print $2}' | cut -d'/' -f1)
        echo -e "IP Address: $ip_addr"
        
        # Check connectivity
        if ping -c 1 8.8.8.8 &> /dev/null; then
            echo -e "${GREEN}Internet connection: Active${NC}"
        else
            echo -e "${RED}Internet connection: Failed${NC}"
        fi
    else
        echo -e "${RED}No network interface found${NC}"
    fi
}

# Function to check running services
check_services() {
    print_header "CRITICAL SERVICES"
    
    # List of services to check (customize as needed)
    services=("ssh" "cron")
    
    for service in "${services[@]}"; do
        if systemctl is-active --quiet $service 2>/dev/null; then
            echo -e "$service: ${GREEN}Running${NC}"
        else
            echo -e "$service: ${RED}Not Running${NC}"
        fi
    done
}

# Main execution
clear
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   SYSTEM HEALTH MONITORING DASHBOARD   ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo -e "Generated: $(date '+%Y-%m-%d %H:%M:%S')"

check_uptime
check_cpu
check_memory
check_disk
check_load
check_network
check_services

echo -e "\n${BLUE}========================================${NC}"
echo -e "${BLUE}Monitoring Complete${NC}"
echo -e "${BLUE}========================================${NC}\n"
#!/bin/bash

set -u

full_name="Subhamay Bhattacharyya"
service_name="nginx"
target_url="http://localhost"
disk_warning_threshold=80
disk_failure_threshold=90
memory_warning_mb=100
base_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
report_dir="$base_dir/reports"
report_file="$report_dir/linux-health-report.txt"

checks=(
	check_service
	check_port
	check_http
	check_disk
	check_memory
)

pass_count=0
warning_count=0
failure_count=0

mkdir -p "$report_dir"

: > "$report_file"

write_line() {
	echo "$1" | tee -a "$report_file"
}

mark_pass() {
	write_line "[PASS] $1"
	pass_count=$((pass_count + 1))
}

mark_warning() {
	write_line "[WARN] $1"
	warning_count=$((warning_count + 1))
}

mark_failure() {
	write_line "[FAIL] $1"
	failure_count=$((failure_count + 1))
}

print_header() {
	write_line "========================================"
	write_line "Linux Incident Triage Report"
	write_line "========================================"
	write_line "Full Name: $full_name"
	write_line "Timestamp: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
	write_line "Hostname: $(hostname)"
	write_line "Target Service: $service_name"
	write_line "Target URL: $target_url"
	write_line ""
}

check_service() {
	if systemctl is-active --quiet "$service_name"
	then
		mark_pass "Nginx service is active"
	else
		mark_failure "Nginx service is not active"
	fi
}

check_port() {
	if ss -ltn | awk 'NR > 1 {print $4}' | grep -qE ':80$'
	then
		mark_pass "Port 80 is listening"
	else
		mark_failure "Port 80 is not listening"
	fi
}

check_http() {
	local http_code

	http_code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 5 "$target_url" || true)
	if [ -z "$http_code" ]
	then
		http_code="000"
	fi

	if [ "$http_code" = "200" ]
	then
		mark_pass "Local HTTP check returned status $http_code"
	else
		mark_failure "Local HTTP check returned status $http_code"
	fi
}

check_disk() {
	local disk_usage

	disk_usage=$(df -P / | awk 'NR == 2 {gsub("%", "", $5); print $5}')
	if [ "$disk_usage" -ge "$disk_failure_threshold" ]
	then
		mark_failure "Root disk usage is ${disk_usage}%"
	elif [ "$disk_usage" -ge "$disk_warning_threshold" ]
	then
		mark_warning "Root disk usage is ${disk_usage}%"
	else
		mark_pass "Root disk usage is ${disk_usage}%"
	fi
}

check_memory() {
	local available_memory

	available_memory=$(free -m | awk '/^Mem:/ {print $7}')
	if [ "$available_memory" -lt "$memory_warning_mb" ]
	then
		mark_warning "Available memory is ${available_memory} MB"
	else
		mark_pass "Available memory is ${available_memory} MB"
	fi
}

capture_recent_logs() {
	local log_output

	write_line ""
	write_line "Recent Nginx service logs (last 5 lines):"
	log_output=$(journalctl -u "$service_name" --no-pager -n 5 2>/dev/null || true)
	if [ -n "$log_output" ]
	then
		echo "$log_output" | sed 's/^/ /' | tee -a "$report_file"
	else
		write_line " No readable Nginx journal entries were found."
	fi
}

print_summary() {
	local overall_status
	local script_exit_code

	if [ "$failure_count" -gt 0 ]
	then
		overall_status="FAIL"
		script_exit_code=2
	elif [ "$warning_count" -gt 0 ]
	then
		overall_status="WARN"
		script_exit_code=1
	else
		overall_status="HEALTHY"
		script_exit_code=0
	fi

	write_line ""
	write_line "Summary:"
	write_line "PASS: $pass_count"
	write_line "WARN: $warning_count"
	write_line "FAIL: $failure_count"
	write_line "Overall Status: $overall_status"
	write_line "Script Exit Code: $script_exit_code"
	write_line "Report File: $report_file"
	return "$script_exit_code"
}

print_header

for check_function in "${checks[@]}"
do
	"$check_function"
done

capture_recent_logs
print_summary
exit $?
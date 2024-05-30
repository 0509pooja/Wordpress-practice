#!/bin/bash

LOG_DIR="/var/log/nginx"
ACCESS_LOG="$LOG_DIR/access.log"
ERROR_LOG="$LOG_DIR/error.log"
TODAY=$(date +"%Y-%m-%d")
REPORT_FILE="$LOG_DIR/log_report_$TODAY.txt"

# Generate log analysis report for access log
{
    echo "Nginx Log Analysis Report - $TODAY"
    echo "==================================="
    echo "Access Log Analysis:"
    echo "Total Requests:"
    wc -l "$ACCESS_LOG"

    echo ""
    echo "Status Codes:"
    awk '{print $9}' "$ACCESS_LOG" | sort | uniq -c | sort -nr

    echo ""
    echo "Top 10 Requested URLs:"
    awk '{print $7}' "$ACCESS_LOG" | sort | uniq -c | sort -nr | head -n 10
} > "$REPORT_FILE"

# Append error log analysis to the report
{
    echo ""
    echo "Error Log Analysis:"
    echo "Total Errors:"
    wc -l "$ERROR_LOG"

    echo ""
    echo "Top 10 Error Messages:"
    awk '{print $0}' "$ERROR_LOG" | sort | uniq -c | sort -nr | head -n 10
} >> "$REPORT_FILE"

echo "Log analysis report saved to $REPORT_FILE"

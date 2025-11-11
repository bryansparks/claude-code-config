#!/usr/bin/env bash

# Local Metrics Logger (Optional, Lightweight)
# Logs skill usage to local JSON files - NO database required

# Check if local metrics are enabled
METRICS_CONFIG="${HOME}/.claude/config/metrics.yml"
METRICS_MODE=$(grep "^metrics_mode:" "$METRICS_CONFIG" 2>/dev/null | awk '{print $2}')

if [ "$METRICS_MODE" != "local" ]; then
    # Metrics disabled or using centralized mode - exit silently
    exit 0
fi

# Configuration
METRICS_DIR="${HOME}/.claude/metrics"
CURRENT_MONTH=$(date +%Y-%m)
LOG_FILE="${METRICS_DIR}/${CURRENT_MONTH}/skill-usage.json"

# Create directory if it doesn't exist
mkdir -p "${METRICS_DIR}/${CURRENT_MONTH}"

# Function to log a skill invocation
log_skill_usage() {
    local skill_name="$1"
    local status="${2:-success}"
    local duration="${3:-0}"
    local file_count="${4:-0}"

    # Create JSON entry
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local entry=$(cat <<EOF
{
  "timestamp": "$timestamp",
  "skill": "$skill_name",
  "status": "$status",
  "duration_seconds": $duration,
  "files_processed": $file_count
}
EOF
)

    # Append to log file
    if [ -f "$LOG_FILE" ]; then
        # File exists - append with comma
        # Remove last ] from file, add comma and new entry, close ]
        head -n -1 "$LOG_FILE" > "${LOG_FILE}.tmp"
        echo "," >> "${LOG_FILE}.tmp"
        echo "$entry" >> "${LOG_FILE}.tmp"
        echo "]" >> "${LOG_FILE}.tmp"
        mv "${LOG_FILE}.tmp" "$LOG_FILE"
    else
        # File doesn't exist - create new array
        echo "[" > "$LOG_FILE"
        echo "$entry" >> "$LOG_FILE"
        echo "]" >> "$LOG_FILE"
    fi
}

# Function to generate monthly summary
generate_monthly_summary() {
    local month="$1"
    local log_file="${METRICS_DIR}/${month}/skill-usage.json"
    local summary_file="${METRICS_DIR}/${month}/summary.txt"

    if [ ! -f "$log_file" ]; then
        echo "No data for $month"
        return
    fi

    # Use jq if available, otherwise basic analysis
    if command -v jq &> /dev/null; then
        cat > "$summary_file" <<EOF
Metrics Summary for $month
==========================

Skill Usage Counts:
$(jq -r '.[] | .skill' "$log_file" | sort | uniq -c | sort -rn)

Success Rate:
$(jq -r '[.[] | select(.status == "success")] | length' "$log_file") / $(jq 'length' "$log_file") successful

Average Duration:
$(jq '[.[] | .duration_seconds] | add / length' "$log_file") seconds

Total Files Processed:
$(jq '[.[] | .files_processed] | add' "$log_file") files

EOF
    else
        # Basic analysis without jq
        cat > "$summary_file" <<EOF
Metrics Summary for $month
==========================

Total Invocations: $(grep -c '"skill"' "$log_file")

Top Skills:
$(grep '"skill"' "$log_file" | sort | uniq -c | sort -rn | head -5)

EOF
    fi

    echo "Summary generated: $summary_file"
}

# Function to cleanup old logs
cleanup_old_logs() {
    local retention_days="${1:-90}"

    find "$METRICS_DIR" -name "*.json" -type f -mtime +$retention_days -delete
    echo "Cleaned up logs older than $retention_days days"
}

# CLI usage
case "${1:-}" in
    log)
        # Log a skill invocation
        # Usage: local-metrics-logger.sh log <skill_name> [status] [duration] [file_count]
        log_skill_usage "$2" "$3" "$4" "$5"
        ;;

    summary)
        # Generate summary for a month
        # Usage: local-metrics-logger.sh summary [YYYY-MM]
        month="${2:-$CURRENT_MONTH}"
        generate_monthly_summary "$month"
        ;;

    cleanup)
        # Cleanup old logs
        # Usage: local-metrics-logger.sh cleanup [days]
        cleanup_old_logs "$2"
        ;;

    view)
        # View current month's logs
        if [ -f "$LOG_FILE" ]; then
            if command -v jq &> /dev/null; then
                jq '.' "$LOG_FILE"
            else
                cat "$LOG_FILE"
            fi
        else
            echo "No metrics for current month"
        fi
        ;;

    stats)
        # Quick stats
        if [ -f "$LOG_FILE" ]; then
            echo "Metrics for $CURRENT_MONTH:"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

            if command -v jq &> /dev/null; then
                total=$(jq 'length' "$LOG_FILE")
                success=$(jq '[.[] | select(.status == "success")] | length' "$LOG_FILE")

                echo "Total invocations: $total"
                echo "Successful: $success"
                echo ""
                echo "Top 5 skills:"
                jq -r '.[] | .skill' "$LOG_FILE" | sort | uniq -c | sort -rn | head -5
            else
                echo "Install 'jq' for detailed statistics"
                echo "Total invocations: $(grep -c '"skill"' "$LOG_FILE")"
            fi
        else
            echo "No metrics for current month"
        fi
        ;;

    *)
        cat <<EOF
Local Metrics Logger (Optional, Lightweight)

Usage:
  $0 log <skill_name> [status] [duration] [file_count]
      Log a skill invocation

  $0 view
      View current month's raw logs

  $0 stats
      Show quick statistics for current month

  $0 summary [YYYY-MM]
      Generate summary for specified month (default: current)

  $0 cleanup [days]
      Cleanup logs older than N days (default: 90)

Examples:
  $0 log code-review success 45 3
  $0 stats
  $0 summary 2025-11
  $0 cleanup 90

Configuration:
  Edit ~/.claude/config/metrics.yml
  Set metrics_mode: local

Current Status:
  Metrics mode: ${METRICS_MODE:-disabled}
  Storage: $METRICS_DIR

EOF
        ;;
esac

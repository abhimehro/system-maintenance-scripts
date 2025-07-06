#!/bin/bash

# Script to manually test the weekly maintenance job
echo "Testing weekly maintenance job..."
echo "Triggering job manually..."

# Start the job immediately (for testing)
launchctl start com.user.maintenance.weekly

# Wait a moment
sleep 2

# Check the log files
echo -e "\n=== Checking stdout log ==="
if [ -f ~/Scripts/maintenance_weekly.log ]; then
    tail -20 ~/Scripts/maintenance_weekly.log
else
    echo "No stdout log found yet"
fi

echo -e "\n=== Checking stderr log ==="
if [ -f ~/Scripts/maintenance_weekly_error.log ]; then
    tail -20 ~/Scripts/maintenance_weekly_error.log
else
    echo "No stderr log found yet"
fi

echo -e "\n=== Job Status ==="
launchctl list com.user.maintenance.weekly

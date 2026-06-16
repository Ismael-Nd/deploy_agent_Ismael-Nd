#!/bin/bash
#
#

cleanup() {
    echo ""
    echo "Interrupt received! Cleaning up..."

    if [ -d "$PROJECT_DIR" ]; then
        tar -czf "${PROJECT_DIR}_archive.tar.gz" "$PROJECT_DIR"
        rm -rf "$PROJECT_DIR"
        echo "Archived to ${PROJECT_DIR}_archive.tar.gz and removed the directory."
    else
        echo "Nothing to clean up — exiting."
    fi

    exit 1
}

read -p "Enter a name for your project: " input

PROJECT_DIR="attendance_tracker_${input}"

trap cleanup SIGINT

if [ -d "$PROJECT_DIR" ]; then
    echo "Error: '$PROJECT_DIR' already exists. Aborting."
    exit 1
fi

mkdir -p "$PROJECT_DIR/Helpers"
mkdir -p "$PROJECT_DIR/reports"


cp attendance_checker.py "$PROJECT_DIR/"
cp assets.csv "$PROJECT_DIR/Helpers/"
cp config.json "$PROJECT_DIR/Helpers/"
cp reports.log "$PROJECT_DIR/reports/"


read -p "Do you want to update attendance thresholds? (y/n): " answer

if [ "$answer" = "y" ]; then
    read -p "Enter Warning threshold (default 75): " warning
    read -p "Enter Failure threshold (default 50): " failure

    # Validate that BOTH are numbers before touching the file
    if [[ "$warning" =~ ^[0-9]+$ ]] && [[ "$failure" =~ ^[0-9]+$ ]]; then
        sed -i 's/"warning: 75/"warning": $warning/' "$PROJECT_DIR/Helpers/config.json"
        sed -i 's/"failure": 50/"failure": $failure/' "$PROJECT_DIR/Helpers/config.json"
        echo "Config updated."
    else
        echo "Invalid input — thresholds must be numbers. Keeping defaults."
    fi
fi


echo "Running environment health check..."

if python3 --version &> /dev/null; then
    echo "Success: $(python3 --version) is installed."
else
    echo "Warning: python3 was not found on this system."
fi

echo "Setup complete!"




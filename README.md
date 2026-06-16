# Automated Project Bootstrapping — Student Attendance Tracker

A shell script (`setup_project.sh`) that automates the setup of a **Student Attendance Tracker** workspace. It builds the directory structure, places the application files, lets you configure attendance thresholds on the fly, verifies your environment, and cleans up safely if you cancel mid-setup.

This project demonstrates **Infrastructure as Code (IaC)** principles: reproducibility, efficiency, and reliability.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Repository Structure](#repository-structure)
3. [How to Run the Script](#how-to-run-the-script)
4. [What the Script Does](#what-the-script-does)
5. [Updating Attendance Thresholds](#updating-attendance-thresholds)
6. [Triggering the Archive Feature](#triggering-the-archive-feature)
7. [Environment Health Check](#environment-health-check)
8. [Troubleshooting](#troubleshooting)

---

## Prerequisites

Before running the script, make sure you have:

- A **Linux**, **macOS**, or **WSL** (Windows Subsystem for Linux) environment
- **Bash** shell (pre-installed on most Unix-like systems)
- **Python 3** installed (the script will check for this, but the tracker app needs it)
- The following source files placed in the **same folder** as `setup_project.sh`:
  - [`attendance_checker.py`](./attendance_checker.py)
  - [`assets.csv`](./assets.csv)
  - [`config.json`](./config.json)
  - [`reports.log`](./reports.log)

---

## Repository Structure

After cloning the repository, your folder should look like this:

```
deploy_agent_YourUsername/
├── setup_project.sh        # The master script
├── attendance_checker.py   # Source file (copied into the project)
├── assets.csv              # Source file (copied into the project)
├── config.json             # Source file (copied into the project)
├── reports.log             # Source file (copied into the project)
└── README.md               # This file
```

### Source Files

These files must be present in the repository for the script to run. Click any file to view it:

| File | Location in workspace | Description |
|------|----------------------|-------------|
| [`setup_project.sh`](./setup_project.sh) | (root) | The master bootstrapping script |
| [`attendance_checker.py`](./attendance_checker.py) | `attendance_tracker_{input}/` | Main attendance-checking logic |
| [`assets.csv`](./assets.csv) | `attendance_tracker_{input}/Helpers/` | Student/asset data |
| [`config.json`](./config.json) | `attendance_tracker_{input}/Helpers/` | Attendance threshold settings |
| [`reports.log`](./reports.log) | `attendance_tracker_{input}/reports/` | Log output file |

When the script runs, it generates the following workspace:

```
attendance_tracker_{input}/
├── attendance_checker.py
├── Helpers/
│   ├── assets.csv
│   └── config.json
└── reports/
    └── reports.log
```

Here `{input}` is the project name you type when prompted (for example, typing `2024` creates `attendance_tracker_2024/`).

---

## How to Run the Script

Follow these steps in your terminal:

**Step 1 — Clone the repository**

```bash
git clone https://github.com/YourUsername/deploy_agent_YourUsername.git
cd deploy_agent_YourUsername
```

**Step 2 — Make the script executable**

This gives the script permission to run:

```bash
chmod +x setup_project.sh
```

**Step 3 — Run the script**

```bash
./setup_project.sh
```

> Alternatively, you can run it without changing permissions by calling Bash directly:
> ```bash
> bash setup_project.sh
> ```

**Step 4 — Follow the prompts**

The script will ask you for:
- A **project name** (used to name the workspace folder)
- Whether you want to **update the attendance thresholds** (`y`/`n`)

That's it — the workspace is created automatically.

---

## What the Script Does

The script runs through the following stages, in order:

1. **Asks for a project name** and builds the parent directory name.
2. **Registers a signal trap** so it can clean up if you cancel.
3. **Checks for existing directories** to avoid overwriting your work.
4. **Creates the directory structure** (`Helpers/` and `reports/`).
5. **Copies the application files** into their correct locations.
6. **Prompts for configuration changes** and edits `config.json` if requested.
7. **Runs a health check** to confirm Python 3 is installed.
8. **Prints a success message** when setup is complete.

---

## Updating Attendance Thresholds

The Student Attendance Tracker uses two thresholds stored in `config.json`:

| Threshold | Default | Meaning                              |
|-----------|---------|--------------------------------------|
| Warning   | 75%     | Below this, the student is warned    |
| Failure   | 50%     | Below this, the student fails        |

When the script asks **"Do you want to update attendance thresholds? (y/n)"**:

- Type **`n`** to keep the defaults.
- Type **`y`** to enter new values. You will be prompted for the Warning and Failure values.

**Note:** The script validates your input. If you enter anything that is **not a number** (for example, letters or symbols), the script rejects it and keeps the default values so the config file is never corrupted.

---

## Triggering the Archive Feature

The script includes a **safety mechanism** for interruptions. If you cancel the script while it is still running, it does not leave a half-built mess behind.

**To trigger it:**

1. Run the script as normal.
2. While it is executing, press **`Ctrl + C`** (this sends the `SIGINT` signal).

**What happens next:**

- The script **catches** the interrupt instead of crashing.
- It **bundles** the current state of the project into a compressed archive named:
  ```
  attendance_tracker_{input}_archive.tar.gz
  ```
- It **deletes** the incomplete project directory to keep your workspace clean.
- It prints a confirmation message and exits.

This means you can always recover your interrupted work from the archive, and you never have leftover broken folders cluttering your workspace.

> **Tip for testing/demo:** If the script finishes too quickly to press `Ctrl + C` in time, you can add a short `sleep` pause inside the build stage to give yourself a window to interrupt it.

---

## Environment Health Check

Before finishing, the script verifies that **Python 3** is available on your system by running `python3 --version`.

- If Python 3 **is found**, you'll see a success message showing the installed version.
- If Python 3 **is missing**, you'll see a warning so you know to install it before using the tracker.

---

## Troubleshooting

| Problem | Likely Cause | Fix |
|---------|--------------|-----|
| `Permission denied` when running | Script is not executable | Run `chmod +x setup_project.sh` |
| `Error: directory already exists` | A workspace with that name exists | Choose a different name, or delete the old folder |
| Config values don't change | The `sed` pattern doesn't match the text in `config.json` | Open `config.json` and make sure the pattern in the script matches the actual key/value format |
| `cp: cannot stat ...` | Source files aren't in the same folder | Move the `.py`, `.csv`, `.json`, and `.log` files next to the script |
| Archive not created on `Ctrl + C` | Script finished before you interrupted | Add a `sleep` pause to extend the run time |

---

[![Watch the video to see the full setup] <img width="1138" height="638" alt="image" src="https://github.com/user-attachments/assets/14133288-2fe4-4e73-a1a8-59f06f5a1752" />
](https://www.loom.com/share/173c600fe70f470c9ffc656929fc550d)

## Author

**Ismael Ndagijimana** — [GitHub: @Ismael-Nd](https://github.com/Ismael-Nd)

African Leadership University — Individual Summative Lab

# Engine Showcase: Modular Bash Installer

A professional demonstration of advanced Bash scripting, automating the deployment of a full-stack Laravel environment.

## Overview

This project is a **technical showcase** of how Bash, combined with [Gum](https://github.com/charmbracelet/gum), can be used to build a modular, interactive, and robust CLI tool. It automates everything from environment checks to GitHub deployment.

> **Note:** This repository is a snapshot for demonstration purposes. The active development of this engine continues in a private project.

## Key Features

- **Interactive UI:** Powered by `gum` for a modern terminal experience.
- **Stack:** Laravel, Livewire, MySQL & SQLite in memory for testing (showcase-specific)
- **Modular Architecture:** Framework-specific logic (Laravel) is separated from shared core utilities.
- **End-to-End Automation:**
  - Automated Database setup (MySQL with dedicated user).
  - Apache Vhost configuration and activation with support for subdomains (Wildcard ServerAlias).
  - Integration of additional packages via data-lists.
  - CI/CD ready: Automated GitHub repository creation and initial push with test badges.
- **Defensive Scripting:** Includes environment validation, dependency checks before execution and includes service-ready synchronization to prevent 503 errors during cold starts in wsl2.
- **Production-ready Security:** Unlike default installers that often rely on root access, this engine follows the principle of least privilege. It automatically provisions a dedicated MySQL user and database, ensuring the local environment mirrors a secure production setup.

## Architectural Choices & Developer Experience (DX)

To ensure a seamless **"one-click-install"** within a WSL2 environment, several high-impact design decisions were made:

1. **Bridging the WSL2/Windows Boundary:** WSL2 lives in an isolated network environment, meaning Linux `/etc/hosts` changes do not affect the Windows browser. The script solves this by safely invoking PowerShell from within Bash at the _start_ of the process. This handles the required Windows UAC Administrator prompt immediately, allowing the developer to safely walk away while the rest of the stack installs fully autonomously.
2. **Dual-Protocol Resolution (IPv4 & IPv6):** Modern browsers like Google Chrome prioritize IPv6 (`::1`) over IPv4 (`127.0.0.1`). The installer maps both protocols simultaneously to eliminate potential loading delays or connection timeouts.
3. **Encapsulated Logging:** For maximum debugging convenience, Apache `ErrorLog` and `CustomLog` outputs are piped directly into the project's root directory rather than global system folders.
4. **Decoupled Post-Install Automation via Makefile:** While the engine utilizes Bash and Composer to download and install optional packages, all subsequent framework bootstrapping—such as running database migrations (`php artisan migrate`), publishing vendor assets (`vendor:publish`), or configuring package stubs—is offloaded to a dedicated `Makefile`. This separates infrastructure tasks (package delivery) from application lifecycle operations (package activation), keeping the codebase clean, highly maintainable, and declarative.
5. **Idempotent Package Sync & State Persistence:** To support reliable updates and prevent redundant installations, the engine implements state management using a local history log (`.installed_packages.log`). During subsequent runs on an existing project, the script parses this file, compares it against the master package list, and dynamically filters out already provisioned packages. This guarantees that Composer dependencies are never double-processed and destructive post-install hooks are never re-executed.

## Project Structure

- `setup-project`: The main entry point (orchestrator)
- `modules/shared/lib/functions`: Core functions
- `modules/shared/scripts`: Core shared utility scripts
- `modules/shared/data-lists`: External configuration files for package management (keeping code DRY)
- `modules/laravel/scripts`: Specific installation scripts for the Laravel framework
- `modules/laravel/data-lists`: Configuration files for Laravel framework
- `modules/laravel/lib/snippets`: Text snippets for Laravel framework
- `Makefile.packages`: Containing post-install logic related to installed packages
- `.installed_packages`: Containing the history of installed extra packages per installed app
- `.installed_apps`: Containing the history of installed apps
- `README.md`

## Requirements

- WSL2 / Linux (Ubuntu recommended)
- [Gum](https://github.com/charmbracelet/gum)
- PHP, Composer, MySQL, Laravel Installer and GitHub CLI (`gh`)

## Troubleshooting

Logs for the framework installation process are stored in /tmp/laravel_install.log and are automatically cleared upon the next run.

## Cleanup & Uninstallation

If you are finished testing and want to completely revert all changes made by the installer, you can use the standalone destroy script.

This will safely and automatically remove the project directory, database, dedicated database user, Apache vhost configs, and clean up the Windows `hosts` file entries within a few seconds.

Make the script executable and run it with the project name as an argument:

```bash
chmod +x destroy-project
./destroy-project <project_name>
```

---

_Created as a showcase for Bash Scripting and DevOps automation._

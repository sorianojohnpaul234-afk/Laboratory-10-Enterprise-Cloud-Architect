# Enterprise Cloud Architect: Secure Multi-Tier Web Application (WordPress + MySQL)

**Course:** CCM101 - Cloud Computing  
**Author:** John Paul S. Ferrer (BSIT, University of Eastern Pangasinan)  
**Instructor:** Jenkielyn C. Torres  

## Overview
This repository contains the infrastructure-as-code configuration, automated backup script, and operational manual for deploying a containerized WordPress and MySQL 8.0 stack on Ubuntu Server using Docker Compose, UFW firewall hardening, and scheduled Cron backups.

## Repository Contents
- `docker-compose.yml` — Multi-tier WordPress and MySQL service orchestration with health checks, isolated bridge network (`wp_net`), and persistent volumes (`db_data`, `wp_data`).
- `backup.sh` — Automated Bash backup script for MySQL database dumps, WordPress file volume archives, and 7-day retention cleanup.
- `OPERATIONAL_MANUAL.md` — Complete standard operating procedures for verification, testing, security hardening, backup automation, troubleshooting, and reflection.

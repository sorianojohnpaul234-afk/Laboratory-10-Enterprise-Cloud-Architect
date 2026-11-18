# UNIVERSITY OF EASTERN PANGASINAN
**College of Information Technology**  
**CCM101 - Cloud Computing**  

## ENTERPRISE CLOUD ARCHITECT OPERATIONAL MANUAL
**Project:** Secure Multi-Tier Web Application (WordPress + MySQL)  
**Prepared by:** John Paul S. Ferrer  
**Course & Year:** Bachelor of Science in Information Technology (BSIT)  
**Instructor:** Jenkielyn C. Torres  
**Date:** November 2026  

---

### 1. INTRODUCTION
#### 1.1 Purpose of the Manual
This operational manual documents the standard operating procedures for configuring, verifying, testing, securing, backing up, and maintaining the Secure Multi-Tier Web Application built with WordPress and MySQL on Ubuntu Server (`cloudnove-wp`).

#### 1.2 Project Overview
The project demonstrates a containerized, multi-tier web application hosted on an Ubuntu Server (`cloudnove-wp`) virtual machine inside Oracle VirtualBox using a Bridged network adapter (`192.168.100.135`). WordPress operates as the frontend content management system, while MySQL 8.0 serves as the isolated backend database tier over a private bridge network (`wp_net`) with persistent named Docker volumes (`db_data`, `wp_data`).

#### 1.3 System Architecture
    [Windows Host Computer / Web Browser]
             | (HTTP Access via [http://192.168.100.135:80](http://192.168.100.135:80) & SSH Port 22)
             v
    [Oracle VirtualBox VM: Ubuntu Server (cloudnove-wp | 192.168.100.135)]
             | (Protected by UFW Firewall: Allow 22, 80 | Deny Incoming)
             v
    [Docker Engine + Docker Compose (/opt/wordpress)]
        |                                      |
        v                                      v
    [WordPress Container]  <---(wp_net)--->  [MySQL 8.0 Container]
      (Host Port 80:80)                      (Internal Port 3306 Only)
        |                                      |
        v                                      v
    [Persistent Volume: wp_data]           [Persistent Volume: db_data]
      (/var/www/html)                        (/var/lib/mysql)

---

### 2. ENVIRONMENT VERIFICATION
- **SSH Access:** `ssh vbuser@192.168.100.135`
- **OS & IP Verification:** `lsb_release -a` and `hostname -I` (`192.168.100.135`)
- **Docker Verification:** `docker --version`, `docker compose version`, and `sudo systemctl status docker`
- **Project Directory:** `/opt/wordpress` containing `docker-compose.yml` and `.env`

---

### 3. APPLICATION CONFIGURATION & TESTING
- **Validate Config:** `docker compose config`
- **Deploy & Inspect:** `docker compose up -d && docker compose ps`
- **Port & Volume Verification:** `docker compose port wordpress 80` (`0.0.0.0:80->80/tcp`) and `docker volume ls` (`wordpress_db_data`, `wordpress_wp_data`)
- **Web & Persistence Test:** Published live operational manual post at `[http://192.168.100.135](http://192.168.100.135)` and verified data persistence across `docker compose down && docker compose up -d`.

---

### 4. SECURITY CONFIGURATION
- **UFW Firewall Rules:** `sudo ufw default deny incoming`, `sudo ufw default allow outgoing`, `sudo ufw allow 22/tcp`, `sudo ufw allow 80/tcp`, `sudo ufw enable`
- **Database & Credential Isolation:** MySQL port `3306` is not published to the host and is accessible only inside `wp_net`. Credentials are isolated in `/opt/wordpress/.env` and excluded from GitHub.

---

### 5. DATABASE BACKUP AND AUTOMATION
- **Backup Script (`/opt/scripts/backup.sh`):** Dumps MySQL (`db_<TIMESTAMP>.sql.gz`), archives `wordpress_wp_data` (`wp_files_<TIMESTAMP>.tar.gz`) to `/opt/backups`, logs to `/var/log/wp_backup.log`, and enforces a 7-day retention policy (`find /opt/backups -type f -mtime +7 -delete`).
- **Cron Schedule (Daily at 2:00 AM):** `0 2 * * * /opt/scripts/backup.sh >> /var/log/wp_backup.log 2>&1`

---

### 6. ACADEMIC INTEGRITY AND AI DISCLOSURE
AI assistance was utilized during this laboratory activity for command syntax verification, virtualized networking/SSH troubleshooting, and documentation structuring. All server deployments, container configurations, firewall rules, backup executions, and verification tests were independently executed and validated by the author.

---

### 7. FINAL REFLECTION
Completing the Enterprise Cloud Architect laboratory activity provided practical experience in provisioning, securing, and automating a multi-tier web application on Linux infrastructure. Using Docker Compose demonstrated service decoupling, health-checked startup ordering, private bridge network isolation, and persistent volume storage. Implementing UFW firewall rules enforced least-privilege network exposure, while automating daily MySQL and file backups via Bash and Cron established reliable disaster recovery practices.

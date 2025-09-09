# TODO.md – Project Roadmap

This is the step-by-step TODO list to complete the Docker infrastructure project.
Follow in order — check items off as you progress.

---

## 📍 Phase 0: Preparation

* [ ] Install **Docker** and **Docker Compose** on your VM
* [ ] Install **Make** (build automation)
* [ ] Set up **project folder structure** as required in subject
* [ ] Configure `/etc/hosts` → add `127.0.0.1 <your_login>.42.fr`
* [ ] Create `.gitignore` to exclude secrets, `.env`, volumes, etc.

---

## 📍 Phase 1: Core Services Setup

### Step 1: Docker Network

* [ ] In `docker-compose.yml`, define a custom **bridge network**

### Step 2: MariaDB Container

* [ ] Write `Dockerfile` (base: Alpine or Debian)
* [ ] Install and configure **MariaDB server**
* [ ] Use environment variables for DB credentials (stored in `.env`)
* [ ] Configure DB persistence with volume → `/var/lib/mysql`
* [ ] Mount DB password/credentials from `secrets/`
* [ ] Ensure container runs with `restart: always`

### Step 3: WordPress Container

* [ ] Write `Dockerfile` (base: Alpine or Debian)
* [ ] Install **php-fpm** and WordPress
* [ ] Configure php-fpm to run in foreground (PID 1 best practice)
* [ ] Connect to MariaDB using environment variables
* [ ] Mount WordPress files volume → `/var/www/html`
* [ ] Ensure container runs with `restart: always`

### Step 4: NGINX Container

* [ ] Write `Dockerfile` (base: Alpine or Debian)
* [ ] Install **NGINX**
* [ ] Generate TLS certificates (OpenSSL or mkcert)
* [ ] Configure NGINX:

  * [ ] Reverse proxy to WordPress php-fpm service
  * [ ] Enforce TLSv1.2 and TLSv1.3 only
  * [ ] Redirect traffic to HTTPS (443 only)
* [ ] Mount TLS certificates securely
* [ ] Ensure container runs with `restart: always`

### Step 5: Environment & Secrets

* [ ] Create `.env` file → store environment variables (DB user, DB name, domain, etc.)
* [ ] Store sensitive data in `secrets/` (e.g., passwords, root password)
* [ ] Reference `.env` and secrets in `docker-compose.yml`

---

## 📍 Phase 2: Project Automation

### Step 6: Makefile

* [ ] Write a `Makefile` with targets:

  * [ ] `make build` → build all images
  * [ ] `make up` → run docker-compose
  * [ ] `make down` → stop containers
  * [ ] `make clean` → remove containers, images, volumes
  * [ ] `make restart` → rebuild and restart project

---

## 📍 Phase 3: Validation & Testing

### Step 7: Test Services

* [ ] Start containers: `make up`
* [ ] Check MariaDB persistence → stop & restart, DB should survive
* [ ] Open `https://<your_login>.42.fr` in browser → verify NGINX TLS
* [ ] Verify WordPress setup connects to MariaDB
* [ ] Create required users in WordPress DB (admin + regular user)

### Step 8: Test Resilience

* [ ] Kill a container → ensure it **auto-restarts**
* [ ] Restart VM → check project comes back with `make up`

---

## 📍 Phase 4: Bonus Services (Optional)

* [ ] Add **Redis** container → connect via WP plugin
* [ ] Add **FTP server** container → link to WordPress volume
* [ ] Add **Adminer** container → manage MariaDB via web UI
* [ ] Add **static website** (HTML/JS or other language except PHP)
* [ ] Add a custom useful service of your choice

---

## 📍 Phase 5: Final Review

* [ ] Verify `.gitignore` → no secrets committed
* [ ] Check `Makefile` → all commands functional
* [ ] Check `.env` variables are used properly
* [ ] Validate WordPress admin username rule (no `admin/administrator` variants)
* [ ] Prepare explanation for each service, configuration, and security choice



### thinks to do letter
🔹 1. Make initdb.sh idempotent

    Right now, the script always runs user creation on every container start. If you restart the container, MariaDB will complain (users already exist).
    You can wrap SQL creation in IF NOT EXISTS (you already did for users & DB ✅).
    That’s fine, but consider also skipping the ALTER USER root... if already set. For now, you can leave it — it won’t  break, just slower startup.

  2.write later to configure wp-config.php in wp docker file



<!-- DB_ROOT_PASSWORD=Gahmed1234
DB_NAME=wordpress
DB_ADMIN_USER=wpadmin
DB_ADMIN_PASSWORD=gahmed1234
DB_USER=wpuser
DB_USER_PASSWORD=user1234
DB_HOST=mariadb
WP_URL=https://gahmed.42.fr
WP_TITLE=MyWordPress
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=ahmed1234
WP_ADMIN_EMAIL=admin@example.com
WP_USER=user
WP_PASSWORD=ahmed123
WP_EMAIL=user@example.com -->
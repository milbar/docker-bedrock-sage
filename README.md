# Docker Bedrock Sage

A modern WordPress stack that combines Docker, Bedrock, and Sage for a streamlined development experience.

## Overview

This project provides a complete WordPress development environment using:

- **Docker** for containerization
- **Bedrock** for WordPress boilerplate with improved folder structure
- **Sage** as a modern WordPress theme with Tailwind CSS and Vite

## Requirements

- Docker and Docker Compose
- PHP 8.1 or higher
- Node.js 20.0.0 or higher
- Composer

## Getting Started

### Setup

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/docker-bedrock-sage.git
   cd docker-bedrock-sage
   ```

2. Create a `.env` file from the example:
   ```bash
   cp .env.example .env
   ```

3. Start the Docker containers:
   ```bash
   docker-compose up -d
   ```

4. Access your WordPress site at http://localhost:8080

### Docker Compose Startup Process

When you run `docker-compose up`, the following happens:

1. **Container Creation**: Docker creates and starts all services defined in `docker-compose.yml`:
   - `appserver`: PHP container that runs WordPress
   - `webserver`: Nginx web server
   - `database`: MariaDB database
   - `node`: Node.js container for theme development

2. **Dependency Resolution**: Containers start in the correct order based on the `depends_on` configuration:
   - `database` starts first
   - `appserver` starts after the database is ready
   - `webserver` starts after the appserver is ready
   - `node` starts independently

3. **Initialization Process**:
   - The `appserver` container runs Composer to install PHP dependencies
   - WordPress is automatically installed and configured
   - The Sage theme dependencies are installed
   - The `node` container installs npm packages and starts the development server

#### Useful Docker Compose Commands and Flags

- **Start containers in detached mode**:
  ```bash
  docker-compose up -d
  ```
  The `-d` flag runs containers in the background, freeing up your terminal.

- **Rebuild containers**:
  ```bash
  docker-compose up --build
  ```
  The `--build` flag forces Docker to rebuild images, useful after changing Dockerfiles or dependencies.

- **Start specific services**:
  ```bash
  docker-compose up webserver database
  ```
  You can specify which services to start if you don't need all of them.

- **Start services with profiles**:
  ```bash
  docker-compose --profile myadmin --profile mail up -d
  ```
  This starts optional services like PHPMyAdmin and MailHog.

- **View container logs**:
  ```bash
  docker-compose logs -f
  ```
  The `-f` flag follows the log output in real-time.

- **Stop containers**:
  ```bash
  docker-compose down
  ```
  Stops and removes containers, networks, and volumes.

### Development Tools

- **PHPMyAdmin**: Available at http://localhost:8081 (optional, start with `docker-compose --profile myadmin up -d`)
- **MailHog**: Available at http://localhost:8025 (optional, start with `docker-compose --profile mail up -d`)

## Project Structure

```
docker-bedrock-sage/
├── config/                  # WordPress configuration files
├── docker/                  # Docker configuration files
├── web/                     # Web root directory
│   ├── app/                 # WordPress content directory
│   │   ├── mu-plugins/      # Must-use plugins
│   │   ├── plugins/         # WordPress plugins
│   │   ├── themes/          # WordPress themes
│   │   │   └── sage/        # Sage theme
│   │   └── uploads/         # Uploaded media files
│   └── wp/                  # WordPress core (don't modify)
└── vendor/                  # Composer dependencies
```

## Development Workflow

### Theme Development

The Sage theme is located at `web/app/themes/sage`. To work on the theme:

1. Access the Node.js container:
   ```bash
   docker-compose exec node sh
   ```

2. Or use the running Node.js container which automatically watches for changes:
   ```bash
   # The container runs npm run dev automatically
   ```

3. Access the development server with HMR at http://localhost:5173

### WordPress Development

1. Access the PHP container:
   ```bash
   docker-compose exec appserver sh
   ```

2. Use WP-CLI commands:
   ```bash
   wp plugin install example-plugin --activate
   ```

## Building for Production

1. Build the theme assets:
   ```bash
   docker-compose exec node sh -c "cd /var/www/html/web/app/themes/sage && npm run build"
   ```

2. For deployment, you'll need to:
   - Set `WP_ENV=production` in your production `.env` file
   - Update the URLs in the `.env` file to match your production domain
   - Ensure all security keys are unique for production

## GitHub Workflow Deployment

This project uses GitHub Actions for automated deployment to staging environments. The workflow is defined in `.github/workflows/staging.yml`.

### Deployment Process

When code is pushed to the `master` branch, the following automated process occurs:

1. **Build Process**:
   - The repository is checked out
   - Node.js 22.16.0 and PHP 8.3 are set up
   - Composer dependencies are installed (excluding dev dependencies)
   - Theme dependencies are installed and assets are compiled with `npm run build`

2. **Deployment with Rclone**:
   - Rclone is configured using secure GitHub secrets
   - Files are synchronized to the remote server using the command:
     ```
     rclone sync --transfers 5 --checkers 10 --exclude-from=".deploy-exclude" ./ remote:SERVER_PATH
     ```
   - The `.deploy-exclude` file specifies which files/directories should not be deployed

3. **Exclusions**:
   Files listed in `.deploy-exclude` are not transferred to the server, including:
   - Development files (`.git`, `.github`, etc.)
   - Docker configuration files
   - Local environment files
   - Node modules and other build artifacts

### Manual Deployment

You can also trigger the deployment manually through the GitHub Actions interface using the "workflow_dispatch" event.

## Technologies Used

- **WordPress**: 6.8.1
- **PHP**: 8.1+
- **MariaDB**: Latest LTS
- **Nginx**: Alpine
- **Node.js**: 20+
- **Vite**: 6.2.0
- **Tailwind CSS**: 4.0.9

## License

MIT

## Credits

This project is based on:
- [Bedrock](https://roots.io/bedrock/) by Roots
- [Sage](https://roots.io/sage/) by Roots

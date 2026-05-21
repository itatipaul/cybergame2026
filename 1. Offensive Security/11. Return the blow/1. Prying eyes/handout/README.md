# Tiny Auth App

A minimal Node.js web application with authentication, Docker-compose ready.

## Features

- Express.js web framework
- Session-based authentication
- Simple login/logout
- Protected dashboard
- Docker-compose compatible

## Quick Start

### Local Development

1. Run the app:
   ```bash
   npm start
   ```

2. Open http://localhost:3000

### Demo Credentials

- **Username:** admin | **Password:** password123
- **Username:** user | **Password:** user123

## Docker Deployment

### Using Docker Compose

```bash
docker-compose up --build
```

The app will be available at http://localhost:3000

## Project Structure

```
.
├── app.js                 # Main Express application
├── package.json          # Dependencies
├── Dockerfile           # Docker image configuration
├── docker-compose.yml   # Docker Compose configuration
├── public/
│   ├── login.html       # Login page
│   └── dashboard.html   # Protected dashboard page
└── node_modules/        # Dependencies (committed to repo)
```

## Environment Variables

- `PORT` - Server port (default: 3000)
- `NODE_ENV` - Set to `production` in Docker

## Building Docker Image

```bash
# Build the image
docker build -t tiny-auth-app .

# Run the image
docker run -p 3000:3000 \
  -v $(pwd):/app \
  -v $(pwd)/node_modules:/app/node_modules \
  tiny-auth-app
```

# PWNed by BadHaxor:3
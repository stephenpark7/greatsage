# GreatSage

This monorepo contains the codebases for both the client and server sides of the GreatSage project.

## Tech Stack

- **Client**: React, TypeScript
- **Server**: Ruby on Rails
- **Deployment**: Docker

## Directory Structure

    greatsage/
        client/  # Client-side code
            src/
            public/
            package.json
            ...
        server/  # Server-side code
            src/
            config/
            package.json
            ...

## Server Details

The server includes a lightweight authentication system using Ruby on Rails 7's has_secure_password method. Access tokens are stored in memory, while refresh tokens are stored securely as HTTPOnly cookies with HTTPS and SameSite=Secure attributes.

### Features

- **CORS**: Cross-Origin Resource Sharing
- **CSP**: Content Security Policy
- **Token Management**: Includes token revocation and protection against timing attacks
- **Testing**: Extensive RSpec coverage, including penetration testing for security


## Setup Instructions

To run the server and client together using Docker Compose:

1. Build the server and client: `docker-compose build`

2. Start the server and client: `docker-compose up -d`

You can also run the server or client separately using `npm start`, but you'll need to set up the database yourself in that case.

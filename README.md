# GreatSage

This monorepo contains both the client and server codebases for the GreatSage project.

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


## Tech Stack

- React, TypeScript
- Ruby on Rails
- Docker

## Instructions

First build the server and client: `docker-compose build`

To run server and client: `docker-compose up -d`

## Ports used

3000 for React development server (front-end)

3001 for Ruby on Rails server (back-end)

# Nexus Orchestrator Project

This is the main repository for the Nexus Orchestrator, a multi-agent system with a FastAPI backend and a React-based web UI.

## Project Structure

- **/gpt-nexus**: The core FastAPI backend service.
- **/nexusmind-web-ui**: The React (Vite + TypeScript) frontend application.
- **/agents**: Contains the individual Python-based agent applications.
- **orchestrator.py**: The main script to kick off multi-agent tasks.
- **docker-compose.yml**: Defines the services (backend, redis, postgres) for local development.

## Getting Started

1.  Review `docker-compose.yml` and create a `.env` file for your database credentials.
2.  Run `docker-compose up --build` to start the services.
3.  The backend API will be available at `http://localhost:8000`.
4.  Navigate to the `nexusmind-web-ui` directory, run `npm install` and then `npm run dev` to start the frontend.

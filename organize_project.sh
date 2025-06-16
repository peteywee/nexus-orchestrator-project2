#!/bin/bash

# This script reorganizes the project files from various backup locations
# into a new, clean directory structure in `./nexus_project`.

# --- Configuration ---
NEW_PROJECT_ROOT="nexus_project"
BACKEND_API_SRC="nexus_project_root_Backup/gpt-nexus"
DOCKER_COMPOSE_SRC="nexus_project_root_Backup/docker-compose.yml"
WEB_UI_SRC="nexus-orchestrator-project2_Backup/nexusmind-web-ui"

# --- Main Execution ---
echo "--- Starting Project Reorganization ---"

# 1. Create the new clean project structure
echo "1. Creating new directory structure at ./${NEW_PROJECT_ROOT}/"
mkdir -p "${NEW_PROJECT_ROOT}/gpt-nexus"
mkdir -p "${NEW_PROJECT_ROOT}/agents"

# 2. Move core backend application and Docker configuration
echo "2. Moving core backend and Docker configuration..."
if [ -f "${DOCKER_COMPOSE_SRC}" ]; then
    mv "${DOCKER_COMPOSE_SRC}" "${NEW_PROJECT_ROOT}/"
    echo "   - Moved docker-compose.yml"
else
    echo "   - WARNING: docker-compose.yml not found."
fi

if [ -d "${BACKEND_API_SRC}" ]; then
    # Move only the contents, not the directory itself
    mv ${BACKEND_API_SRC}/* "${NEW_PROJECT_ROOT}/gpt-nexus/"
    echo "   - Moved gpt-nexus backend source files."
else
    echo "   - WARNING: Backend source directory '${BACKEND_API_SRC}' not found."
fi

# 3. Move the entire React Web UI application
echo "3. Moving the React web UI..."
if [ -d "${WEB_UI_SRC}" ]; then
    mv "${WEB_UI_SRC}" "${NEW_PROJECT_ROOT}/"
    echo "   - Moved nexusmind-web-ui application."
else
    echo "   - WARNING: Web UI source directory '${WEB_UI_SRC}' not found."
fi

# 4. Move previously created agent and orchestrator scripts
#    Assuming they exist in the current working directory as per prior steps.
echo "4. Moving agent and orchestrator scripts..."
if [ -f "orchestrator.py" ]; then
    mv orchestrator.py "${NEW_PROJECT_ROOT}/"
    echo "   - Moved orchestrator.py"
fi
if ls gpt-agent_* 1> /dev/null 2>&1; then
    mv gpt-agent_* "${NEW_PROJECT_ROOT}/agents/"
    echo "   - Moved gpt-agent_* directories."
fi


# 5. Generate a missing Dockerfile for the backend for completeness
echo "5. Generating placeholder Dockerfile for backend..."
cat << 'EOF' > "${NEW_PROJECT_ROOT}/gpt-nexus/Dockerfile"
# Dockerfile for gpt-nexus FastAPI backend
FROM python:3.11-slim

WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port and run the application
EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
EOF
echo "   - Created ${NEW_PROJECT_ROOT}/gpt-nexus/Dockerfile"

# 6. Generate a root README.md for project clarity
echo "6. Generating root README.md..."
cat << 'EOF' > "${NEW_PROJECT_ROOT}/README.md"
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
EOF
echo "   - Created ${NEW_PROJECT_ROOT}/README.md"

# 7. Note on ignored files
echo ""
echo "--- Important Notes ---"
echo "- The 'site-packages' directory from 'nexus-orchestrator-project2_Backup' has been intentionally IGNORED."
echo "  It contains library backups, not project source code. Dependencies should be managed by 'requirements.txt'."
echo "- The original backup directories can now be safely deleted if you are satisfied with the new structure."
echo ""
echo "--- Reorganization Complete ---"
echo "A clean project structure has been created in ./${NEW_PROJECT_ROOT}/"
echo "You can inspect it with 'tree ${NEW_PROJECT_ROOT}' or 'ls -lR ${NEW_PROJECT_ROOT}'"

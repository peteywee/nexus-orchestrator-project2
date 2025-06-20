#!/bin/bash

set -e

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m"

echo -e "${YELLOW}[INFO] Refreshing submodules...${NC}"

git pull origin main
git submodule update --remote --merge

if [[ -n $(git status --porcelain) ]]; then
  echo -e "${YELLOW}[INFO] Changes detected in submodule pointers.${NC}"
  git add .
  git commit -m "🔁 Submodule sync via failsafe"
  git push origin main
  echo -e "${GREEN}[✓] Submodule changes pushed.${NC}"
else
  echo -e "${GREEN}[✓] No submodule changes detected.${NC}"
fi

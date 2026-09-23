#!/usr/bin/env bash
# Lance tous les contrôles locaux : documentation, backend (format, tests, build), frontend (format, tests, build).
# Prérequis : dépendances frontend installées (`npm ci` dans frontend/).
set -euo pipefail

cd "$(dirname "$0")/.."

echo "== Documentation"
scripts/check-docs.sh

echo "== Backend"
(cd backend && ./mvnw -B -q verify)

echo "== Frontend"
[ -d frontend/node_modules ] || { echo "Dépendances absentes : lancer npm ci dans frontend/." >&2; exit 1; }
(cd frontend && npm run -s format:check && npm run -s test:ci && npm run -s build)

echo "Tous les contrôles sont passés."

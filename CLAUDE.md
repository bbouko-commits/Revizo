# Claude Code

Les règles communes du projet sont dans `AGENTS.md`, importé ci-dessous. Ce fichier ne contient que ce qui est propre à Claude Code.

@AGENTS.md

## Spécificités Claude Code

- Les instructions locales sont chargées via `backend/CLAUDE.md` et `frontend/CLAUDE.md`, qui importent l'`AGENTS.md` de leur dossier lorsque vous lisez des fichiers de ces dossiers.
- Les sous-agents du projet sont dans `.claude/agents/`. Ce sont des adaptateurs des fiches `docs/agents/*.md` : n'appelez que ceux que la tâche justifie (voir `docs/agents/README.md`).
- Ce dépôt ne versionne aucune permission Claude Code. Les autorisations restent celles de votre configuration personnelle et du mode choisi.

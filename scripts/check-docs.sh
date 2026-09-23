#!/usr/bin/env bash
# Contrôle la documentation et les rôles :
# - liens Markdown relatifs [texte](cible) résolus, hors blocs de code ;
# - chaque fiche docs/agents/<rôle>.md a ses sections et ses adaptateurs Claude Code et Codex, et inversement.
# Non vérifiés : liens de référence ([texte]: cible), ancres (#section), URL externes.
set -euo pipefail
shopt -s nullglob

cd "$(dirname "$0")/.."
errors=0
fail() { echo "ERREUR: $*" >&2; errors=$((errors + 1)); }

# Cibles de liens d'un fichier Markdown, blocs ``` et code `inline` retirés.
link_targets() {
  awk '/^[[:space:]]*```/ { fence = !fence; next } !fence' "$1" \
    | sed -E 's/`[^`]*`//g' \
    | grep -oE '\]\([^)]+\)' \
    | sed -E 's/^\]\((.*)\)$/\1/; s/^<([^>]*)>.*$/\1/; s/[[:space:]]+"[^"]*"$//' \
    || true
}

while IFS= read -r -d '' file; do
  dir=$(dirname "$file")
  while IFS= read -r target; do
    target=${target%%#*}
    [[ -z "$target" || "$target" =~ ^[a-zA-Z][a-zA-Z0-9+.-]*: ]] && continue
    target=${target//%20/ }
    if [[ "$target" == /* ]]; then path=".$target"; else path="$dir/$target"; fi
    [[ -e "$path" ]] || fail "$file : lien cassé vers $target"
  done < <(link_targets "$file")
done < <(git -c core.quotePath=false ls-files -z --cached --others --exclude-standard -- '*.md')

sections=("Mission" "Quand l'appeler" "Entrées minimales" "Livrables" "Outils et écriture" "Critères de fin" "Limites")
roles=0
for fiche in docs/agents/*.md; do
  role=$(basename "$fiche" .md)
  [[ "$role" == "README" ]] && continue
  roles=$((roles + 1))
  for section in "${sections[@]}"; do
    grep -qx "## $section" "$fiche" || fail "$fiche : section « $section » manquante"
  done
  claude=".claude/agents/$role.md"
  codex=".codex/agents/$role.toml"
  if [[ -f "$claude" ]]; then
    grep -qx "name: $role" "$claude" || fail "$claude : 'name: $role' attendu"
    grep -q '^description: ' "$claude" || fail "$claude : description manquante"
    grep -q "docs/agents/$role.md" "$claude" || fail "$claude : ne renvoie pas à sa fiche"
  else
    fail "adaptateur Claude Code manquant : $claude"
  fi
  if [[ -f "$codex" ]]; then
    grep -qx "name = \"$role\"" "$codex" || fail "$codex : 'name = \"$role\"' attendu"
    grep -q '^description = ' "$codex" || fail "$codex : description manquante"
    grep -q '^developer_instructions = ' "$codex" || fail "$codex : developer_instructions manquant"
    grep -q "docs/agents/$role.md" "$codex" || fail "$codex : ne renvoie pas à sa fiche"
  else
    fail "adaptateur Codex manquant : $codex"
  fi
done

for adapter in .claude/agents/*.md .codex/agents/*.toml; do
  role=$(basename "${adapter%.*}")
  [[ -f "docs/agents/$role.md" ]] || fail "$adapter : aucune fiche docs/agents/$role.md"
done

if ((errors > 0)); then
  echo "$errors erreur(s)." >&2
  exit 1
fi
echo "Documentation OK ($roles rôles)."

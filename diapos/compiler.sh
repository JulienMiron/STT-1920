#!/bin/sh
# Compile toutes les diapos STT-1920 en deux versions :
#   Chapitre_Xx.pdf             : présentation (avec dévoilements \uncover, \pause…)
#   Chapitre_Xx-imprimable.pdf  : version « handout » (une page par diapo)
# Usage : sh compiler.sh              (tous les chapitres)
#         sh compiler.sh Chapitre_2a  (un seul chapitre)
set -e
cd "$(dirname "$0")"

if [ $# -gt 0 ]; then
  fichiers=$(for f in "$@"; do echo "${f%.tex}.tex"; done)
else
  fichiers=$(ls Chapitre_*.tex)
fi

for f in $fichiers; do
  echo "=== $f ==="
  latexmk "$f"
  latexmk -usepretex='\PassOptionsToClass{handout}{beamer}' -jobname=%A-imprimable "$f"
  # Supprime les fichiers auxiliaires (garde les PDF)
  latexmk -c "$f" >/dev/null 2>&1
  latexmk -c -jobname=%A-imprimable "$f" >/dev/null 2>&1
done

#!/bin/sh
# Produit les diapos annotées dans ../H26/Chapitre_Xx-annote.pdf
#   sh compiler.sh               (tous les chapitres annotés)
#   sh compiler.sh Chapitre_2a   (un seul)
# Étapes : 1) version imprimable de la diapo originale (pdflatex) dans .build/
#          2) superposition des annotations (lualatex)
#          3) vérification : chaque \annot{page}{titre} tombe sur la bonne diapo
set -e
cd "$(dirname "$0")"
mkdir -p .build ../H26

if [ $# -gt 0 ]; then
  chapitres=$(for f in "$@"; do basename "${f%.tex}"; done)
else
  chapitres=$(ls Chapitre_*.tex | sed 's/\.tex$//')
fi

for c in $chapitres; do
  echo "=== $c ==="
  # 1) Version imprimable (une page par diapo) à partir de ../../Chapitre_Xx.tex
  if [ ! -f ".build/$c-imprimable.pdf" ] || [ "../../$c.tex" -nt ".build/$c-imprimable.pdf" ]; then
    for i in 1 2; do
      (cd ../.. && pdflatex -interaction=nonstopmode -halt-on-error \
        -output-directory="Annotées/sources/.build" -jobname="$c-imprimable" \
        "\PassOptionsToClass{handout}{beamer}\input{$c.tex}" >/dev/null) \
        || { echo "Erreur pdflatex : voir .build/$c-imprimable.log"; exit 1; }
    done
  fi
  # 2) Annotations
  #    (deux passes : les calques TikZ se positionnent sur la page à la 2e)
  for i in 1 2; do
    lualatex -interaction=nonstopmode -halt-on-error -output-directory=.build "$c.tex" >/dev/null \
      || { echo "Erreur lualatex : voir .build/$c.log"; grep -A3 '^!' ".build/$c.log" | head -20; exit 1; }
  done
  cp ".build/$c.pdf" "../H26/$c-annote.pdf"
  # 3) Vérification des titres
  python3 outils/verifier.py "$c"
done

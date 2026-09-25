# Consignes — diapos annotées STT-1920 (H26)

## But
Produire, pour chaque chapitre, un PDF des diapos **avec les annotations que l'enseignant écrirait en classe** (sur iPad), comme dans ses diapos annotées de H22. Le résultat : `diapos/Annotées/H26/Chapitre_Xx-annote.pdf`.

## Dossiers
- `diapos/Annotées/sources/` : ici. `annot.sty` (commandes), `compiler.sh`, `outils/grille.py`, `outils/verifier.py`, `polices/`.
- `diapos/Annotées/sources/Chapitre_Xx.tex` : **le fichier que vous écrivez** (un par partie).
- `diapos/Chapitre_Xx.tex` : source Beamer des diapos (à lire pour le contenu, **ne pas modifier**).
- `diapos/Annotées/H22/` : PDF annotés à la main par l'enseignant en H22 (ancienne version des diapos). **Source d'inspiration principale** : ce qu'il écrivait, où, comment. Les annotations sont aplaties dans les pages ; il faut les regarder en image :
  `gs -q -dNOPAUSE -dBATCH -sDEVICE=png16m -r60 -dFirstPage=K -dLastPage=M -sOutputFile=/tmp/.../h22_%02d.png "../H22/FICHIER.pdf"` (scratchpad : `/private/tmp/claude-501/-Users-jmiron-Documents-GitHub-STT-1920/16c53adf-26bc-4c21-b9ec-c5a735760965/scratchpad/annot_<chapitre>/`). Des planches contact (python3 + PIL) aident à survoler.

## Style observé en H22 (à reproduire)
- Écriture en **majuscules au feutre**, couleurs vives : **vert** (couleur principale : solutions, calculs), **violet** (explications, étiquettes), **orange**, **rouge** (mises en garde, réponses importantes), **rose/jaune** en surligneur.
- **Solutions complètes des exemples et des quiz** écrites dans l'espace libre (les diapos « à compléter » ou avec espace vide sont faites pour ça).
- **Mots-clés entourés ou surlignés**, **flèches** vers une étiquette (« ← DEGRÉS DE LIBERTÉ », « MARGE D'ERREUR »), parties de formules nommées.
- **Petits dessins** : arbres, diagrammes de Venn hachurés, courbes normales avec zone ombrée, droites de régression, tableaux.
- **Pages blanches insérées** (fond papier) pour les développements longs, les questions posées à la classe ou un exemple supplémentaire.
- Toutes les diapos ne sont pas annotées : les pages de section, titre, références et « Réponses aux exemples » restent en général intactes ; les définitions reçoivent au plus un surlignage ou une précision.

## Commandes (voir `annot.sty`)
Coordonnées en **mm**, origine **en bas à gauche**, diapo = 160 × 90 mm.
```latex
\annot{22}{Exemple 1 (suite)}{          % page de la version imprimable + début du titre attendu
  \ecrire[vert][9]{(16,58)}{TEXTE\\ $P(A)=1-P(A^c)$}   % ancré en haut à gauche ; \\ = nouvelle ligne
  \ecrirec[rouge][10]{(80,20)}{CENTRÉ}
  \entourer[violet]{(cx,cy)}{rx}{ry}    % ellipse à main levée
  \encadrer[rouge]{(x1,y1)}{(x2,y2)}
  \souligner[vert]{(x1,y)}{(x2,y)}
  \surligner[jaune]{(x1,y1)}{(x2,y2)}   % ou [rose]
  \fleche[violet][20]{(x1,y1)}{(x2,y2)} % flèche courbe (courbure en degrés, négatif = autre sens)
  \trait[vert]{(0,0) -- (5,5) -- (9,2)} % trait libre (tout chemin TikZ)
  \coche{(x,y)}  \croix{(x,y)}
  \cloche[bleu]{(cx,y0)}{largeur}{hauteur}   % petite courbe normale
  % TikZ libre permis : \draw[crayon, orange] ... ; \fill[orange, opacity=.4] ... ; styles crayon, crayon lisse, pointe
}
\apres{22}{ ...mêmes commandes, sur une page papier insérée après la page 22... }
\produire{Chapitre_2a}
```
- Maths : `$...$` normal (lettres et chiffres sortent dans la police manuscrite). Pas de caractères Unicode mathématiques (₁, ∩, ←) hors mode math : écrire `$M_1$`, `$\cap$`, `$\leftarrow$`.
- Écrire en **MAJUSCULES** (comme l'enseignant), accents compris. Taille 8 à 11 pt sur les diapos, 11 à 14 pt sur les pages blanches.
- Le 2e argument de `\annot` doit être le **début du titre** de la diapo (le script vérifie qu'il correspond).

## Méthode
1. `cd diapos/Annotées/sources && sh compiler.sh Chapitre_Xx` (construit aussi `.build/Chapitre_Xx-imprimable.pdf`). Le squelette peut être vide au départ : `\documentclass{article}\usepackage{annot}\begin{document}\produire{Chapitre_Xx}\end{document}`.
2. `python3 outils/grille.py Chapitre_Xx --titres` : liste des pages.
3. `python3 outils/grille.py Chapitre_Xx 20-30` : PNG avec grille mm dans `.build/grilles/` → **regarder** pour trouver l'espace libre et les coordonnées des mots à entourer.
4. Écrire les annotations, recompiler, puis `python3 outils/grille.py Chapitre_Xx 20-30 --annote` et **regarder chaque page annotée** : rien ne doit chevaucher le texte imprimé (sauf entourer/surligner volontairement), rien ne doit sortir de la page, l'écriture doit être lisible. Corriger jusqu'à ce que ce soit propre.
5. **Exactitude** : chaque calcul écrit doit être juste (vérifier avec Rscript/python3) et cohérent avec la diapo « Réponses aux exemples » du chapitre.
6. `compiler.sh` doit finir sans erreur et avec « 0 titre(s) discordant(s) » et sans caractères absents.

## Règles
- Ne modifier **que** `diapos/Annotées/sources/Chapitre_Xx.tex` qui vous est attribué (et produire `../H26/Chapitre_Xx-annote.pdf` via compiler.sh). Ne pas toucher à `annot.sty` : si une commande manque, faites-la en TikZ directement dans votre fichier.
- Ne rien committer.
- Densité visée : à peu près comme H22 — la majorité des exemples, quiz et diapos à compléter sont annotés ; 2 à 6 pages blanches par chapitre.

## Rapport final (court, en français)
Nombre de pages annotées / pages blanches ajoutées, choix notables, points à valider (ex. un calcul ou une interprétation différente de H22).

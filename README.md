# STT-1920 Méthodes statistiques

Ce dépôt contient :

- les **notes de cours** (Quarto), d'après les notes de Claude Bélisle ;
- les **diapositives** (LaTeX/Beamer, classe `BeamerTemplate.cls`) dans `diapos/`.

À chaque `push` sur `main`, GitHub Actions compile les diapos, régénère le
site et le publie sur GitHub Pages. Les PDF ne sont **pas** versionnés : ils
sont produits par la compilation.

## Structure

| Chemin | Contenu |
|---|---|
| `index.qmd`, `0X-*.qmd`, `A-tables.qmd` | Chapitres des notes |
| `diapos.qmd` | Page du site qui liste automatiquement les PDF des diapos |
| `diapos/Chapitre_*.tex` | Sources des diapos (une par chapitre) |
| `diapos/compiler.sh` | Compile les diapos (version présentation + version imprimable) |
| `diapos/latexmkrc` | Configuration de `latexmk` |
| `donnees/`, `R/` | Données et fonctions R utilisées par les notes |
| `.github/workflows/publish.yml` | Compilation et publication automatiques |

## Mise en place (une seule fois)

1. Créer un dépôt vide sur GitHub (ex. `stt1920`).
2. Dans ce dossier :
   ```bash
   git init -b main
   git add .
   git commit -m "Diapos et notes STT-1920"
   git remote add origin git@github.com:VOTRE-UTILISATEUR/stt1920.git
   git push -u origin main
   ```
3. Sur GitHub : *Settings → Pages → Build and deployment → Source :*
   **GitHub Actions**.
4. Remplacer `VOTRE-UTILISATEUR` dans `_quarto.yml`.

Le site sera ensuite à `https://VOTRE-UTILISATEUR.github.io/stt1920/`, avec
les diapos sous l'onglet *Diapositives*.

## Travailler au quotidien

Modifier un `.tex`, puis :

```bash
git commit -am "Chapitre 2a : correction de l'exemple 4"
git push
```

Le suivi se fait dans l'onglet **Actions** du dépôt (environ 3 à 5 minutes).
Si la compilation LaTeX échoue, rien n'est publié et le journal de l'étape
« Compiler les diapos » indique la ligne fautive.

**Ajouter un chapitre :** créer `diapos/Chapitre_3a.tex`. Il est compilé et
ajouté à la page *Diapositives* automatiquement (le titre vient de
`\title{...}`).

## Compiler localement

```bash
sh diapos/compiler.sh              # tous les chapitres
sh diapos/compiler.sh Chapitre_2a  # un seul chapitre
quarto preview                     # aperçu du site avec les PDF
```

Prérequis : une distribution TeX complète (TeX Live ou MiKTeX) avec
`latexmk`, Quarto et R (paquets `knitr`, `rmarkdown`, `png`).

## Logo généré automatiquement

`images/logo.png` (utilisé par `sidebar: logo:`) est régénéré à chaque rendu
à partir de `images/logo-source.png` (la silhouette) et de la couleur
`--accent` définie dans `styles.css` — voir `R/logo.R`, lancé automatiquement
par `project: pre-render:` dans `_quarto.yml`. Pour changer la couleur du
logo, il suffit donc de changer `--accent` dans `styles.css` ; ne pas modifier
`images/logo.png` directement (il sera écrasé au prochain rendu).

## À faire

- Remplacer `diapos/ligne2.png` et `diapos/logo_ul.pdf` (substituts
  temporaires) par les fichiers officiels du gabarit.

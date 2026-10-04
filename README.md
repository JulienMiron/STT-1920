# STT-1920 Méthodes statistiques

Ce dépôt contient :

- un **site** Quarto (racine) : page d'accueil et page *Diapositives* ;
- les **notes de cours** (Quarto), d'après les notes de Claude Bélisle, dans
  `notes/` — un sous-projet Quarto indépendant (type `book`), publié dans
  l'onglet *Notes de cours* ;
- les **diapositives** (LaTeX/Beamer, classe `BeamerTemplate.cls`) dans `diapos/`.

À chaque `push` sur `main`, GitHub Actions compile les diapos, régénère le
site (racine puis `notes/`) et le publie sur GitHub Pages. Les PDF ne sont
**pas** versionnés : ils sont produits par la compilation.

## Structure

Le dépôt est composé de deux projets Quarto indépendants, à la manière de
STT-4300 : la racine (`type: website`) et `notes/` (`type: book`), rendu
directement dans `_site/notes` par la racine.

| Chemin | Contenu |
|---|---|
| `index.qmd` | Page d'accueil du site (racine) |
| `diapos.qmd`, `R/diapos.R` | Page *Diapositives* du site : liste automatiquement les PDF des diapos et les chapitres de `notes/` correspondants |
| `diapos/Chapitre_*.tex` | Sources des diapos (une par chapitre) |
| `diapos/compiler.sh` | Compile les diapos (version présentation + version imprimable) |
| `diapos/latexmkrc` | Configuration de `latexmk` |
| `notes/index.qmd`, `notes/0X-*.qmd`, `notes/A-tables.qmd` | Chapitres des notes (sous-projet `book`) |
| `notes/donnees/`, `notes/R/` | Données et fonctions R utilisées par les notes |
| `notes/images/`, `notes/R/logo.R` | Logo de la sidebar, régénéré automatiquement (voir plus bas) |
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
quarto render                      # rend le site racine (index.qmd, diapos.qmd)
quarto render notes                # rend les notes de cours (sous-projet book)
quarto preview                     # aperçu du site racine avec les PDF
```

Le site racine et `notes/` sont deux projets Quarto indépendants (comme pour
STT-4300) : il faut rendre les deux pour obtenir un site complet dans
`_site/`. `quarto preview` ne prévisualise que le projet racine.

Prérequis : une distribution TeX complète (TeX Live ou MiKTeX) avec
`latexmk`, Quarto et R (paquets `knitr`, `rmarkdown`, `png`).

## Synchronisation automatique vers Global

Ce dépôt est une copie de travail des diapos ; `Global/STT-1920/Diapos`
(archive maîtresse, aussi synchronisée avec Overleaf) reste la référence à
long terme. Un hook Git reporte automatiquement toute correction de
`diapos/*.tex` vers `Global` à chaque commit (copie + commit + push).

**Après un clone frais, l'activer une seule fois** (la config des hooks
n'est pas clonée par Git) :

```bash
git config core.hooksPath .githooks
```

Détails et mode d'emploi manuel : voir l'en-tête de
`scripts/sync-to-global.sh` (`--dry-run` pour simuler, `--all` pour tout
resynchroniser).

## Logo généré automatiquement

`notes/images/logo.png` (utilisé par `sidebar: logo:` et repris sur la page
d'accueil du site) est régénéré à chaque rendu à partir de
`notes/images/logo-source.png` (la silhouette) et de la couleur `--purple`
définie dans `notes/styles.css` — voir `notes/R/logo.R`, lancé automatiquement
par `project: pre-render:` dans `notes/_quarto.yml`. Cette couleur est la même
que celle de STT-4300, SitePerso, STT-1900 et STT-1000 ; pour changer la
couleur du logo, il suffit donc de changer `--purple` dans `notes/styles.css` ;
ne pas modifier `notes/images/logo.png` directement (il sera écrasé au
prochain rendu).

## À faire

- Remplacer `diapos/ligne2.png` et `diapos/logo_ul.pdf` (substituts
  temporaires) par les fichiers officiels du gabarit.

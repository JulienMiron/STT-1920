# Encadré « Diapositives de ce chapitre », inséré dans chaque chapitre de
# notes/ (diapos_chapitre(n)). Le dossier diapos/ et la page diapos.qmd sont
# à la racine du site, donc un niveau au-dessus de notes/ : d'où "../diapos"
# et "../diapos.qmd" ci-dessous.
#
# Les PDF sont produits par diapos/compiler.sh (voir le workflow GitHub) :
#   diapos/Chapitre_Xx.pdf             (présentation)
#   diapos/Chapitre_Xx-imprimable.pdf  (version imprimable)
# Tout nouveau fichier diapos/Chapitre_*.tex est détecté automatiquement.

# Nettoie un titre LaTeX pour l'afficher en Markdown
diapos_nettoyer <- function(t) {
  t <- gsub("\\\\texorpdfstring\\{([^}]*)\\}\\{[^}]*\\}", "\\1", t)
  t <- gsub("\\\\textsuperscript\\{([^}]*)\\}", "\\1", t)
  t <- gsub("\\\\(emph|textbf|textit)\\{([^}]*)\\}", "\\2", t)
  t <- gsub("--", "–", t, fixed = TRUE)
  t <- gsub("\\s*:\\s*", " : ", t)
  trimws(t)
}

# Tableau des diapos : fichier, numéro de chapitre, partie, sections
diapos_infos <- function(dossier = "../diapos") {
  fichiers <- sort(list.files(dossier, pattern = "^Chapitre_[0-9]+[a-z]?\\.tex$"))
  if (length(fichiers) == 0) return(NULL)
  lignes_de <- function(f) readLines(file.path(dossier, f), warn = FALSE, encoding = "UTF-8")
  sections <- function(lignes) {
    s <- grep("^\\\\section", lignes, value = TRUE)
    # \section[court]{long} ou \section{long} : on garde le titre long
    s <- sub("^\\\\section(\\[[^]]*\\])?\\{(.*)\\}\\s*(%.*)?$", "\\2", s)
    s <- sub("^[0-9.]+\\s+", "", s)                   # retire « 2.1 »
    s <- diapos_nettoyer(s)
    s[!grepl("^(Introduction|Synthèse|Quiz)", s)]    # sections sans contenu propre
  }
  base <- sub("\\.tex$", "", fichiers)
  data.frame(
    base     = base,
    chapitre = as.integer(sub("^Chapitre_([0-9]+).*$", "\\1", base)),
    partie   = sub("^Chapitre_[0-9]+", "", base),
    contenu  = vapply(fichiers, function(f) paste(sections(lignes_de(f)), collapse = " · "), ""),
    stringsAsFactors = FALSE
  )
}

# Lien Markdown vers un PDF s'il existe (sinon un tiret)
diapos_lien <- function(base, suffixe = "", texte = "PDF", dossier = "../diapos") {
  pdf <- file.path(dossier, paste0(base, suffixe, ".pdf"))
  if (file.exists(pdf)) sprintf("[%s](%s)", texte, pdf) else "—"
}

# Encadré à placer au début d'un chapitre des notes
diapos_chapitre <- function(n) {
  infos <- diapos_infos()
  if (is.null(infos)) return(invisible())
  sous <- infos[infos$chapitre == n, ]
  if (nrow(sous) == 0) return(invisible())
  cat("::: {.callout-tip collapse=\"false\"}\n## Diapositives de ce chapitre\n\n")
  for (i in seq_len(nrow(sous))) {
    partie <- if (sous$partie[i] == "") sprintf("Chapitre %d", n) else
      sprintf("Partie %d%s", n, sous$partie[i])
    cat(sprintf("- **%s** : %s · %s  \n  *%s*\n", partie,
                diapos_lien(sous$base[i], "", "présentation"),
                diapos_lien(sous$base[i], "-imprimable", "imprimable"),
                sous$contenu[i]))
  }
  # ../diapos.qmd est dans un projet Quarto distinct (la racine du site) :
  # Quarto ne réécrit pas .qmd -> .html à travers une frontière de projet,
  # donc on pointe directement vers le .html rendu.
  cat("\nVoir aussi la page [Diapositives](../diapos.html).\n:::\n")
  invisible()
}

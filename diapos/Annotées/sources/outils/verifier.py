#!/usr/bin/env python3
"""Vérifie que chaque \\annot{page}{titre} vise la bonne diapo.

Compare le titre attendu (lu dans .build/<chap>.log) au début du texte de la
page correspondante de .build/<chap>-imprimable.pdf. Signale aussi les
caractères absents de la police manuscrite.
"""
import os
import re
import sys
import unicodedata

import pypdf

ICI = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def norm(s):
    s = unicodedata.normalize("NFKD", s)
    s = "".join(ch for ch in s if ch.isalnum())
    return s.lower()


def main(chap):
    log = open(os.path.join(ICI, ".build", f"{chap}.log"), encoding="utf-8",
               errors="replace").read()
    r = pypdf.PdfReader(os.path.join(ICI, ".build", f"{chap}-imprimable.pdf"))
    erreurs = 0
    for m in re.finditer(r"ANNOT-VERIF: page (\d+) => (.*)", log):
        page, attendu = int(m.group(1)), m.group(2).strip()
        texte = norm(r.pages[page - 1].extract_text() or "")
        if not texte.startswith(norm(attendu)[:25]):
            erreurs += 1
            debut = (r.pages[page - 1].extract_text() or "").strip().split("\n")[0][:60]
            print(f"  ATTENTION page {page} : attendu « {attendu} », trouvé « {debut} »")
    manquants = sorted(set(re.findall(r"Missing character: There is no (\S+)", log)))
    if manquants:
        print("  Caractères absents de la police :", " ".join(manquants))
    n = len(re.findall(r"ANNOT-VERIF", log))
    print(f"  {n} pages annotées, {erreurs} titre(s) discordant(s)")


if __name__ == "__main__":
    main(sys.argv[1])

#!/usr/bin/env python3
"""Rend des pages d'un chapitre avec une grille en millimètres.

Usage :
  python3 outils/grille.py Chapitre_2a 22            # une page
  python3 outils/grille.py Chapitre_2a 20-30         # plusieurs pages
  python3 outils/grille.py Chapitre_2a 22 --annote   # version annotée (H26)
  python3 outils/grille.py Chapitre_2a --titres      # liste page -> titre

Les PNG sont écrits dans .build/grilles/. Origine en bas à gauche,
lignes fines aux 5 mm, étiquettes aux 10 mm (160 x 90 mm).
À lancer depuis diapos/Annotées/sources/.
"""
import os
import subprocess
import sys

import pypdf
from PIL import Image, ImageDraw

ICI = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BUILD = os.path.join(ICI, ".build")


def source(chap, annote):
    if annote:
        return os.path.join(ICI, "..", "H26", f"{chap}-annote.pdf")
    return os.path.join(BUILD, f"{chap}-imprimable.pdf")


def titres(chap):
    r = pypdf.PdfReader(source(chap, False))
    for i, p in enumerate(r.pages, 1):
        t = (p.extract_text() or "").strip().split("\n")[0][:80]
        print(i, t)


def pages(spec):
    out = []
    for morceau in spec.split(","):
        if "-" in morceau:
            a, b = morceau.split("-")
            out += list(range(int(a), int(b) + 1))
        else:
            out.append(int(morceau))
    return out


def grille(chap, page, annote, dpi=110):
    os.makedirs(os.path.join(BUILD, "grilles"), exist_ok=True)
    suffixe = "-annote" if annote else ""
    png = os.path.join(BUILD, "grilles", f"{chap}{suffixe}-p{page:03d}.png")
    subprocess.run(["gs", "-q", "-dNOPAUSE", "-dBATCH", "-sDEVICE=png16m",
                    f"-r{dpi}", f"-dFirstPage={page}", f"-dLastPage={page}",
                    f"-sOutputFile={png}", source(chap, annote)], check=True)
    im = Image.open(png).convert("RGB")
    w, h = im.size
    mm = w / 160.0
    calque = Image.new("RGBA", im.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(calque)
    for x in range(0, 161, 5):
        c = (0, 120, 255, 110) if x % 10 == 0 else (0, 120, 255, 45)
        d.line([(x * mm, 0), (x * mm, h)], fill=c, width=1)
        if x % 10 == 0:
            d.text((x * mm + 2, h - 12), str(x), fill=(0, 80, 200, 255))
    for y in range(0, 91, 5):
        c = (255, 60, 0, 110) if y % 10 == 0 else (255, 60, 0, 45)
        yy = h - y * mm
        d.line([(0, yy), (w, yy)], fill=c, width=1)
        if y % 10 == 0:
            d.text((2, yy - 12), str(y), fill=(200, 40, 0, 255))
    Image.alpha_composite(im.convert("RGBA"), calque).convert("RGB").save(png)
    print(png)


if __name__ == "__main__":
    args = sys.argv[1:]
    if len(args) < 2:
        print(__doc__)
        sys.exit(1)
    chap = args[0]
    if args[1] == "--titres":
        titres(chap)
    else:
        for p in pages(args[1]):
            grille(chap, p, "--annote" in args)

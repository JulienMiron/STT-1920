# Petits diagrammes de Venn en R de base (pour les chapitres de probabilités)
cercle <- function(cx, cy, r = 1, n = 200) {
  t <- seq(0, 2 * pi, length.out = n)
  cbind(cx + r * cos(t), cy + r * sin(t))
}
# remplir : "A", "B", "union", "inter" ou "aucun"
venn2 <- function(remplir = "aucun", titre = "", col = "#7DC3E5",
                  omega = NULL, un_seul = FALSE) {
  op <- par(mar = c(0.5, 0.5, 1.5, 0.5)); on.exit(par(op))
  plot(NA, xlim = c(0, 6), ylim = c(0, 4), asp = 1, axes = FALSE,
       xlab = "", ylab = "", main = titre)
  rect(0, 0, 6, 4)
  A <- cercle(2.4, 2, 1.2); B <- cercle(3.6, 2, 1.2)
  dans <- function(p, cx) (p[, 1] - cx)^2 + (p[, 2] - 2)^2 <= 1.44
  if (remplir %in% c("A", "union")) polygon(A, col = col, border = NA)
  if (remplir %in% c("B", "union")) polygon(B, col = col, border = NA)
  if (remplir == "inter") {
    t <- seq(-pi / 2, pi / 2, length.out = 200)
    xa <- 2.4 + 1.2 * cos(t); ya <- 2 + 1.2 * sin(t)
    gauche <- xa > 3; pts <- rbind(cbind(xa, ya)[gauche, ],
                                   cbind(3.6 - 1.2 * cos(rev(t)), 2 + 1.2 * sin(rev(t)))[rev(gauche), ])
    polygon(pts, col = col, border = NA)
  }
  polygon(A)
  text(1.3, 3.3, "A", cex = 1.2)
  if (!un_seul) { polygon(B); text(4.7, 3.3, "B", cex = 1.2) }
  text(5.6, 3.6, expression(Omega))
  if (!is.null(omega)) { points(omega[1], omega[2], pch = 19); text(omega[1] + 0.25, omega[2], expression(omega)) }
}

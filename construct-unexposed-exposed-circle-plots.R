setwd("~/erase")

require(grDevices)

xyr <- pack.circles(matrix(c(2,280),ncol = 2), size=c(100, 100), max.iter=1000, overlap=0 )
xyr2 <- pack.circles(matrix(c(2,180),ncol = 2), size=c(100, 100), max.iter=1000, overlap=0 )
  #
  # Simple circle packing algorithm based on inverse size weighted repulsion
  #
  # config   - matrix with two cols: radius, N
  # size     - width and height of bounding rectangle
  # max.iter - maximum number of iterations to try
  # overlap  - allowable overlap expressed as proportion of joint radii

svg(
  filename = "unexposed-exposed-populations.svg",
  width = 5,
  height = 3
)
par(mar = rep(.1,4), mfrow = c(1,1))
plot.new()
plot.window(xlim=c(0,210), ylim=c(0,100), asp = 1)
for (i in 1:nrow(xyr)) {
  draw.circle(xyr[i, 1], xyr[i, 2], xyr[i, 3], "#39397680", "#393976")
}

for (i in 1:nrow(xyr2)) {
  draw.circle(xyr2[i, 1] + 110, xyr2[i, 2], xyr2[i, 3], "#AA393980", "#AA3939")
}

text(50,100,"UNEXPOSED", pos = 3)
text(160, 100, "EXPOSED", pos = 3)

dev.off()


svg(
  filename = "unexposed-exposed-populations-paired.svg",
  width = 5,
  height = 3
)
par(mar = rep(.1,4), mfrow = c(1,1))
plot.new()
plot.window(xlim=c(0,210), ylim=c(0,100), asp = 1)
for (i in 1:nrow(xyr)) {
  draw.circle(xyr[i, 1], xyr[i, 2], xyr[i, 3], "#39397680", "#393976")
}

for (i in 1:nrow(xyr2)) {
  draw.circle(xyr2[i, 1] + 110, xyr2[i, 2], xyr2[i, 3], "#AA393980", "#AA3939")
}

text(50,100,"UNEXPOSED", pos = 3)
text(160, 100, "EXPOSED", pos = 3)

for(i in 1:5){
  lines(
    c(xyr[i, 1],xyr2[i, 1] + 110),
    c(xyr[i, 2],xyr2[i, 2]),
    col = "#5C3A02",
    lwd = 4
  )
  draw.circle(xyr[i, 1], xyr[i, 2], xyr[i, 3] + .5, "#FFC357", "#5C3A02")
  draw.circle(xyr2[i, 1] + 110, xyr2[i, 2], xyr2[i, 3] + .5, "#FFC357", "#5C3A02")

}
dev.off()

svg(
  filename = "unexposed-exposed-one-to-one-paired.svg",
  width = 5,
  height = 3
)
par(mar = rep(.1,4), mfrow = c(1,1))
plot.new()
plot.window(xlim=c(0,210), ylim=c(0,100), asp = 1)
for(y in seq(0, 100, by = 8)){
  for(x in seq(0, 210, by = 24)){
    draw.circle(x, y, 2, "#39397680", "#393976")
    draw.circle(x + 4.5, y, 2, "#AA393980", "#AA3939")
  }
}
dev.off()

svg(
  filename = "unexposed-exposed-two-to-one-paired.svg",
  width = 5,
  height = 3
)
par(mar = rep(.1,4), mfrow = c(1,1))
plot.new()
plot.window(xlim=c(0,210), ylim=c(0,100), asp = 1)
for(y in seq(0, 100, by = 8)){
  for(x in seq(0, 210, by = 24)){
    draw.circle(x, y, 2, "#39397680", "#393976")
    draw.circle(x + 4.5, y, 2, "#39397680", "#393976")
    draw.circle(x + 9, y, 2, "#AA393980", "#AA3939")
  }
}
dev.off()

svg(
  filename = "unexposed-exposed-three-to-one-paired.svg",
  width = 5,
  height = 3
)
par(mar = rep(.1,4), mfrow = c(1,1))
plot.new()
plot.window(xlim=c(0,210), ylim=c(0,100), asp = 1)
for(y in seq(0, 100, by = 8)){
  for(x in seq(0, 210, by = 24)){
    draw.circle(x, y, 2, "#39397680", "#393976")
    draw.circle(x + 4.5, y, 2, "#39397680", "#393976")
    draw.circle(x + 9, y, 2, "#39397680", "#393976")
    draw.circle(x + 13.5, y, 2, "#AA393980", "#AA3939")
  }
}
dev.off()


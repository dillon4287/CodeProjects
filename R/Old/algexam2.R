par(mfrow= c(1,1))
plot(0, 0, xlim= c(-5,5), ylim = c(-5,5), type ="n", axes = F, 
     main = "f", xlab = "x", ylab = "y")
axis(1, pos= c(0,0), labels = F, tck = 0)
axis(2, pos = c(0,0), labels = F, tck = 0)
text(-4,4 ,"Q2", cex = 1.5)
text(4,4, "Q1", cex = 1.5)
text(-4,-4, "Q3", cex = 1.5)
text(4,-4, "Q4", cex = 1.5)
points(-3, 3, pch = 17)
text(-2.5,3, "A(m,n)")
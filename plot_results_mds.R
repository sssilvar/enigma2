#!/usr/bin/env Rscript
library(optparse)
library(calibrate)
# If you don’t have calibrate package, install it using
# install.packages("calibrate")

# Check for arguments
option_list = list(
  make_option(c(
    "-f", "--file"),
    type="character",
    default="HM3mds2R.mds.csv",
    help="CSV File from ENIGMA2 Genetics analysis [HM3mds2R.mds.csv]",
    metavar="character"));

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

# Output filename
plot_filename = file.path(dirname(opt$file), "mdsplot.pdf")

# Plot results
mds.cluster = read.csv(opt$file, header=T);
ur.num = length(mds.cluster$C1) - 988;
colors = rev(c(
  rep("red", ur.num),
  rep("lightblue", 112),
  rep("brown", 84),
  rep("yellow", 113),
  rep("green", 88),
  rep("purple", 86),
  rep("orange", 85),
  rep("grey50", 50),
  rep("black", 88),
  rep("darkolivegreen", 49),
  rep("magenta", 90),
  rep("darkblue", 143)
  ));

pdf(file = plot_filename, width = 7, height = 7)

plot(rev(mds.cluster$C2), rev(mds.cluster$C1),
     col=colors,
     ylab="Dimension 1",
     xlab="Dimension 2",
     pch=20)

legend("bottomright",
       c("My Sample",
         "CEU", "CHB", "YRI",
         "TSI", "JPT", "CHD",
         "MEX", "GIH", "ASW",
         "LWK", "MKK"),
       fill=c("red", "lightblue",
              "brown", "yellow",
              "green", "purple",
              "orange", "grey50",
              "black", "darkolivegreen",
              "magenta", "darkblue"))

# Label your sample points, if you want to know the subject ID
# label of each sample on the graph, uncomment the value below
# (this is optional and you can choose not to do this if you
# are worried about patient information being sent; when you
# send us your MDS plot please make sure the subject ID labels
# are NOT on the graph)

# textxy(mds.cluster$C2[1:ur.num], mds.cluster$C1[1:ur.num],mds.cluster$IID[1:ur.num]) dev.off();

dev.off();
print("[  DONE  ]")

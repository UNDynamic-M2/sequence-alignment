print("Installing required packages...")
deps = readLines("dependencies.txt")
libs = .libPaths()

conds = sapply(libs, function (l) { grepl("rds/homes", l, fixed = TRUE) })
indices = which(conds == TRUE)
priority_lib = NULL

if (length(indices) > 0) {
  priority_lib = libs[indices[1]]
}

if (!is.null(priority_lib)) {
  libs = c(priority_lib, libs)
}

install.packages(deps, repo="http://cran.rstudio.com/", lib = libs)

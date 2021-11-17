# install.R
# Installs the required packages
# The script looks if the BEAR portal home is included
# in the lib paths and uses that. Otherwise it uses the default lib paths (which may not be writable!)
# NOTE: if this script doesn't work please manually install the packages from dependencies.txt

print("Installing required packages...")
deps = readLines("dependencies.txt")
libs = .libPaths()

# Check if there is a lib location in /rds/homes as it's writable
conds = sapply(libs, function (l) { grepl("rds/homes", l, fixed = TRUE) })
indices = which(conds == TRUE)
bear_home_lib = NULL

if (length(indices) > 0) {
  bear_home_lib = libs[indices[1]]
}

if (!is.null(bear_home_lib)) {
  libs = c(bear_home_lib)
  install.packages(deps, repo = "http://cran.rstudio.com/", lib = libs)
} else {
  install.packages(deps, repo = "http://cran.rstudio.com/") 
}

print("Installing required packages...")
deps = readLines("dependencies.txt")
install.packages(deps, repo="http://cran.rstudio.com/")

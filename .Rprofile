## ===========================================================================
## R Global Settings
## ===========================================================================

## Global options -------------------------------------------------------------
# Sys.setenv("LANGUAGE" = "EN") # set language of R message
options(encoding = "UTF-8") # set file encoding
options(useFancyQuotes = FALSE)

## Package download mirrors ---------------------------------------------------
### CRAN packages
options(repos = c(CRAN = "https://mirrors.tuna.tsinghua.edu.cn/CRAN/")) 
### Bioconductor packages
options(BioC_mirror = "https://mirrors.tuna.tsinghua.edu.cn/bioconductor")
# options(repos = c(CRAN = "https://mirrors.pku.edu.cn/CRAN/"))
# options(repos = c(CRAN = "https://mirrors.upm.edu.my/CRAN/"))

### Error message -----------------------------------------
options(error = function() {
  calls <- sys.calls()
  if (length(calls) >= 2L) {
    sink(stderr())
    on.exit(sink(NULL))
    cat("Backtrace:\n")
    calls <- rev(calls[-length(calls)])
    for (i in seq_along(calls)) {
      cat(i, ": ", deparse(calls[[i]], nlines = 1L), "\n", sep = "")
    }
  }
  if (!interactive()) {
    message("Exiting on error")
    q(status = 1)
  }
})

## VSCode plugin setting ---------------------------------------------------
### Format style
options(languageserver.lint_cache = TRUE)
options(languageserver.formatting_style = function(options) {
  styler::tidyverse_style(
    scope = "indention",
    indent_by = options$tabSize
  )
})

### Data table
options(datatable.quiet = TRUE,
  datatable.print.class = TRUE,
  datatable.print.keys = TRUE
)

options(future.rng.onMisuse = "ignore")

### R session
if (interactive() && Sys.getenv("RSTUDIO") == "") {
  Sys.setenv(TERM_PROGRAM = "vscode")
  source(file.path(Sys.getenv(if (.Platform$OS.type == "windows") "USERPROFILE" else "HOME"), ".vscode-R", "init.R"))
}

### Httpgd
### Option1
if (interactive() && Sys.getenv("TERM_PROGRAM") == "vscode") {
  if ("httpgd" %in% .packages(all.available = TRUE)) {
    options(vsc.plot = FALSE, vsc.use_httpgd = FALSE)
    options(device = function(...) {
      httpgd::hgd(silent = TRUE)
      .vsc.browser(httpgd::hgd_url(history = FALSE), viewer = "Beside")
    })
  }
}
### Option2
# if (interactive() && Sys.getenv("TERM_PROGRAM") == "vscode") {
#   if ("httpgd" %in% .packages(all.available = TRUE)) {
#     options(vsc.plot = FALSE)
#     options(device = function(...) {
#       httpgd::hgd(silent = TRUE)
#       .vsc.browser(httpgd::hgd_url(history = FALSE), viewer = "Beside")
#     })
#   }
# }


## Set local custom R library path -----------------------------------------
### Set your custom library location
### Please do not add '/' at the end !!!
# .CUSTOM_LIB <- "~/Library/R" 
# if (!dir.exists(.CUSTOM_LIB)) {
#   dir.create(.CUSTOM_LIB, recursive = TRUE)
# }
# .libPaths(c(.CUSTOM_LIB, .libPaths()))
# message("Using library: ", .libPaths()[1])

## Use pacman to manage R packages -----------------------------------------
### Packages to load when R starts
# if (!requireNamespace("pacman", quietly = TRUE)) {
#   install.packages("pacman", dependencies = TRUE)
# }
# suppressPackageStartupMessages(library(pacman))
# suppressPackageStartupMessages(library(tidyverse))
# ### Relative path
# library(here)
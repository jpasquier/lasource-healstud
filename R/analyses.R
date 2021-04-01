wd <- "~/Projects/LaSource/Guzman - Healthy Students"
date <- "2021-01-25"
load(file.path(wd, "/data/hs_20201119.rda"))
for (z in c(0, 0.5)) {
  if (z == 0) {
    dom_list <- c(NA, names(attr(hs$Domaine, "labels")), "Soins infirmiers")
  } else {
    dom_list <- NA
  }
  s1 <- sub("0\\.5", "05", z)
  for (dom in dom_list) {
    print(paste("Temps :", z, "/ Domaine :", dom))
    s2 <- gsub(" ", "_", iconv(dom, to="ASCII//TRANSLIT"))
    if (is.na(s2)) s2 <- "" else s2 <- paste0("_", s2)
    output_file <- paste0("results/analyses_20210125_T", s1, s2, ".html")
    output_file <- path.expand(file.path(wd, output_file))
    rmd_file <- path.expand(file.path(wd, "R/analyses_20210125.Rmd"))
    tmp_file_1 <- paste0("/tmp/HS_tmp_", round(runif(1) * 10^10), ".Rmd")
    tmp_file_2 <- paste0("/tmp/HS_tmp_", round(runif(1) * 10^10), ".Rmd")
    if (z == 0.5 | !is.na(dom)) {
      system(paste("sed '/<!-- BEGIN PSS10 -->/,/<!-- END PSS10 -->/d'",
                   shQuote(rmd_file), ">", tmp_file_1))
    } else {
      system(paste("cp", shQuote(rmd_file), tmp_file_1))
    }
    if (z != 0.5) {
      system(paste("sed '/<!-- BEGIN PTGI -->/,/<!-- END PTGI -->/d'",
                   tmp_file_1, ">", tmp_file_2))
    } else {
      system(paste("cp", tmp_file_1, tmp_file_2))
    }
    rmarkdown::render(tmp_file_2,
                      params = list(temps = z, date = date, dom = dom),
                      output_file = output_file)
    file.remove(tmp_file_1, tmp_file_2)
  }
}
# https://stackoverflow.com/questions/39550732/
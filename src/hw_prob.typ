#import "@preview/linguify:0.4.1": load_ftl_data, linguify


#let languages = (
  "zh",
  "en",
)
#let lgf_db = eval(load_ftl_data("./L10n", languages))
#let linguify = linguify.with(from: lgf_db)


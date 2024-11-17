#let THEMES = (
  "simple",
  "sketch",
)

#metadata(THEMES) <THEMES>

/// Get the theme main function by name
///
/// - name (str): the name of the theme
/// -> theme
#let get-theme(name) = {
  import "themes/" + name + "/lib.typ": theme
  return theme
}
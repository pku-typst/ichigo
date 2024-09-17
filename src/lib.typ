#import "@preview/valkyrie:0.2.1" as z

#import "model.typ" as model
#import "title.typ": title-content

/// Main document processing function
///
/// / doc (content): the whole document
/// / course-name (str): the name of the course, must be provided
/// / serial-str (str): the serial number of the document, must be provided
/// / author-info (content): the author information, default to `[]`
/// / author-names (array | str): the array of author names, default to `""`
/// / title-style (str | none): expected to be `"whole-page"`, `none` or `"simple"`, default to `"whole-page"`
/// -> doc
#let config(
  doc,
  course-name: none,
  serial-str: none,
  author-info: [],
  author-names: "",
  title-style: "whole-page",
  theme-name: "simple",
  ..opt,
) = {
  let meta = (
    course-name: course-name,
    serial-str: serial-str,
    author-info: author-info,
    author-names: author-names,
    ..opt.named(),
  )
  title-style = z.parse(title-style, model.title-style)
  meta = z.parse(meta, model.meta-schema)
  z.parse(theme-name, model.theme-name)

  let theme = model.get-theme(theme-name)
  theme = z.parse(theme(meta), model.theme-schema, scope: (theme-name,))

  return {
    set document(
      title: meta.course-name + "-" + meta.serial-str,
      author: meta.author-names,
    )
    title-content(meta, theme, title-style)
    doc
  }
}

#let prob(..args) = {
  assert(false, "Not implemented")
}

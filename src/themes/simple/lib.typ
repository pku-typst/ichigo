#let export = (
  title: (),
)

#let theme(meta) = {
  return (
    title: (
      whole-page: () => {
        return [
          #v(40pt)
          #align(center)[
            #set text(font: ("Microsoft Sans Serif", "SimHei"))
            #text(size: 28pt, weight: "bold")[
              #meta.course-name
            ]

            #text(size: 18pt)[
              #meta.serial-str
            ]

            #text(size: 12pt, font: "Kaiti SC")[
              #meta.author-info
            ]
          ]

          #pagebreak(weak: true)
        ]
      },
    ),
  )
}
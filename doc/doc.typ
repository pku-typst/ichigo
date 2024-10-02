#import "@preview/numbly:0.1.0": numbly
#import "@preview/indenta:0.0.3": fix-indent
#import "@preview/codly:1.0.0": codly, codly-init

// Scripting

#let param-table(..docs) = {
  let headers = ([参数], [类型], [默认值], [说明])
  let items = docs
    .pos()
    .flatten()
    .chunks(headers.len())
    .map(((p, t, dv, dscr)) => (
        strong(p),
        t,
        if dv == none [无(位置参数)] else {
          dv
        },
        dscr,
      ))
    .flatten()

  figure({
    set align(left)
    table(
      columns: (25%, 20%, 20%, 35%),
      row-gutter: 0.6em,
      stroke: none,
      table.header(..headers),
      table.hline(),
      ..items
    )
  })
}

#let dict-struct(..docs) = {
  let headers = ([字段], [类型], [说明])
  let items = docs
    .pos()
    .flatten()
    .chunks(headers.len())
    .map(((k, v, d)) => (
        strong(k),
        v,
        d,
      ))
    .flatten()

  figure({
    set align(left)
    table(
      columns: (30%, 30%, 40%),
      row-gutter: 0.6em,
      stroke: none,
      table.header(..headers),
      table.hline(),
      ..items
    )
  })
}

// Layout

#set text(lang: "zh")

#set text(font: (
  "New Computer Modern",
  "Source Han Serif SC",
))

#show ref: underline
#show link: underline
#show ref: set text(fill: color.eastern)
#show link: set text(fill: color.eastern)

#show: codly-init.with()

#codly(languages: (
  typ: (
    name: "Typst",
    color: rgb("#00beb4"),
  ),
))

#set heading(numbering: numbly("{1:一}、", "{2}.", "{2}.{3}."))

#set par(first-line-indent: 2em)

#show: fix-indent()

// Document

#align(center)[#text(size: 24pt)[Ichigo 作业模板]]

#outline(depth: 2, indent: 1em)

= 使用须知

ichigo 提供了一个功能库和一份文档模板, 对功能定制要求不高的用户可以直接修改模板使用.

功能库提供了 `config` 和 `prob` 两个函数, 前者用于处理文档内容, 后者用于产生统一形式的文档内容

= 接口文档

== `config`

=== 参数

// @typstyle off
#param-table(
  `doc`, `content`, none, [文档内容],
  `serial-str`, `str | none`, `none`, [作业编号(e.g. 第四周作业), 必须主动传入, 若希望留空请使用 `""`],
  `theme-name`, `str`, `"simple"`, [主题名称, 可用主题见@available-themes],
  `title-style`, `str | none`, `"whole-page"`, [标题样式, 可选值为 `"whole-page"`, `"simple"` 和 `none`],
  `author-info`, `content`, `[]`, [作者信息, 默认为 `[]`],
  `course-name`, `str`, `none`, [课程名称, 默认为 `none`, 必须主动传入, 若希望留空请使用 `""`],
  `author-names`, `str | array`, `""`, [作者姓名(列表), 用于填入文档的 metadata, 默认为 `""`],
  `heading-numberings`, `array`, `(none, none, "(1)", "a.")`, [标题编号格式, 默认为 `(none, none, "(1)", "a.")`, 具体格式参考 `numbly` 包的文档],
)

=== 使用方法

用于 `show` 语句中可将整个文档置于 `config` 的 `doc` 参数中, 结合 Typst 的 `.with` 语法, 给出以下示例:

```typ
#show: config.with(
  course-name: "高等 Typst 学",
  serial-str: "第一次作业",
  author-names: "?sjfh",
  author-info: [sjfh from PKU-Typst]
)

这里写作业内容
```

== `prob`

=== 参数

// @typstyle off
#param-table(
  `question`, `content`, none, [题目内容],
  `solution`, `content`, none, [解答内容],
  `title`, `content | auto`, `auto`, [标题, 默认为自动生成编号],
)

=== 使用方法

示例:

```typ
#prob[
  你好呀
][
  爱用 Typst 的小朋友
]

#prob(title: [小试牛刀])[
  请给出 Fibonacci 数列的第 25 项
][
  #let f(n) = {
    if n <= 2 {
      return 1
    }
    return f(n - 1) + f(n - 2)
  }
  #f(25)
]
```

= 主题开发 <theme-dev>

== 现有可用主题

#import "../src/themes.typ": THEMES
#figure(
  table(
    columns: (15%, 60%),
    table.header([主题名称], [预览图]),
    ..THEMES.map(t => (t, [暂无])).flatten()
  ),
  caption: [可用主题],
) <available-themes>

== 主题开发

新建主题需要在 `/src/themes/{theme_name}/lib.typ` 文件中包含一个名为 `theme` 的函数, 其中 `{theme_name}` 为主题名称.

对 `theme` 函数的要求为:

- 接受一个位置参数 `meta`, 格式见 @struct-meta
- 返回一个 `theme`, 格式见 @struct-theme

并记得将该主题名称加入 `/src/themes.typ` 文件中的 `THEMES` 列表中.

== 特定数据结构

=== `meta` <struct-meta>

`dictionary` 类型, 包含以下字段:

// @typstyle off
#dict-struct(
  `course-name`, `str`, [课程名称],
  `serial-str`, `str`, [作业编号],
  `author-info`, `content`, [作者信息],
  `author-names`, `str | array`, [作者姓名(列表), 用于填入文档的 metadata],
)

=== `theme` <struct-theme>

`dictionary` 类型, 包含以下字段:

// @typstyle off
#dict-struct(
  `title`, `dictionary`, [标题样式],
  `page-setting`, `dictionary`, [页面设置],
  `fonts`, `dictionary`, [字体设置],
)

其中 `title` 字段包含以下字段:

// @typstyle off
#dict-struct(
  `whole-page`, `function`, [整页模式],
  `simple`, `function`, [简易模式],
)

`page-setting` 字段包含以下字段:

// @typstyle off
#dict-struct(
  `header`, `function`, [页眉],
  `footer`, `function`, [页脚],
)

`fonts` 字段包含以下字段:

// @typstyle off
#dict-struct(
  `heading`, link(<struct-font-schema>)[`font-schema`], [标题],
  `text`, link(<struct-font-schema>)[`font-schema`], [正文],
  `equation`, link(<struct-font-schema>)[`font-schema`], [公式],
)

=== `font-schema` <struct-font-schema>

`str` 或 `tuple` 类型


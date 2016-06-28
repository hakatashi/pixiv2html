require! {
  'pixiv-novel-parser': {Parser}
  'escape-html': escape
  assert
}

module.exports = (text, {transforms = {}, type = \html} = {}) ->
  parser = new Parser!
  parser.parse text
  root-node = parser.tree

  pages = []
  current-page = ''
  current-line-html = []

  send-line = ->
    line-html = current-line-html.join ''

    if current-line-html.length isnt 0 and line-html is ''
      if type is \xhtml
        current-page += '<br/>'
      else
        current-page += '<br>'
    else if line-html isnt ''
      current-page += "<p>#{line-html}</p>"

    current-line-html := []

  send-page = ->
    send-line!
    pages.push current-page
    current-page := ''

  serialize = (node) ->
    | Array.is-array node
      node.map serialize .join ''

    | node.type is \text
      escape node.val

    | node.type is \tag
      switch node.name
        | \rb
          [
            '<ruby>'
            "<rb>#{escape node.ruby-base}</rb>"
            '<rp>（</rp>'
            "<rt>#{escape node.ruby-text}</rt>"
            '<rp>）</rp>'
            '</ruby>'
          ].join ''

        | \jump
          if typeof! transforms.jump is \Function
            transforms.jump node.page-number
          else
            [
              """<a href="" class="jump" data-page="#{escape node.page-number}">"""
              "#{escape node.page-number}ページヘ"
              '</a>'
            ].join ''

        | \jumpuri
          [
            """<a href="#{escape node.uri}">"""
            serialize node.title
            '</a>'
          ].join ''

        | \pixivimage
          if typeof! transforms.pixivimage is \Function
            transforms.pixivimage node.illust-ID, node.page-number
          else if node.page-number is null
            """<img src="" class="pixivimage" data-illust-id="#{escape node.illust-ID}">"""
          else
            """<img src="" class="pixivimage" data-illust-id="#{escape node.illust-ID}" data-page="#{escape node.page-number}">"""

  process = (node) ->
    | Array.is-array node
      for token in node
        process token

    | node.type is \text
      lines = node.val.split /\r?\n/

      current-line-html.push escape lines.0

      for line in lines[1 to]
        send-line!
        current-line-html.push escape line

    | node.type is \tag
      switch node.name
        | \chapter
          send-line!
          title = serialize node.title

          if typeof! transforms.chapter is \Function
            current-page += transforms.chapter title
          else
            current-page += "<h1>#{title}</h1>"

        | \newpage
          send-page!

        | otherwise
          current-line-html.push serialize node

  process root-node

  send-page!

  return pages

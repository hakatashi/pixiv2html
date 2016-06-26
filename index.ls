require! {
  'pixiv-novel-parser': {Parser}
  'escape-html': escape
  assert
}

module.exports = (text) ->
  parser = new Parser!
  parser.parse text
  root-node = parser.tree

  pages = []
  current-page = ''
  current-line-html = []

  send-line = ->
    line-html = current-line-html.join ''

    if current-line-html.length isnt 0 and line-html is ''
      current-page += '<br>'
    else if line-html isnt ''
      current-page += "<p>#{line-html}</p>"

    current-line-html := []

  serialize = (node) ->
    | Array.is-array node
      node.map serialize .join ''

    | node.type is \text
      node.val

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
          current-page += "<h1>#{escape title}</h1>"

        | otherwise
          current-line-html.push serialize node

  process root-node
  send-line!

  return [current-page]

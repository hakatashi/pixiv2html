require! {
  'pixiv-novel-parser': {Parser}
  'escape-html': escape
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
    | Array.isArray node
      for token in node
        serialize token

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
          current-page += "<h1>#{escape node.title}</h1>"

  serialize root-node
  send-line!

  return [current-page]

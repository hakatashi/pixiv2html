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
  current-line = []

  send-line = ->
    line-text = current-line.join ''

    if current-line.length isnt 0 and line-text is ''
      current-page += '<br>'
    else if line-text isnt ''
      current-page += "<p>#{line-text}</p>"

    current-line := []

  serialize = (node) ->
    | Array.isArray node
      for token in node
        serialize token

    | node.type is \text
      lines = node.val.split /\r?\n/

      current-line.push lines.0

      for line in lines[1 to]
        send-line!
        current-line.push line

    | node.type is \tag
      switch node.name
        | \chapter
          send-line!
          current-line.push "<h1>#{escape node.title}</h1>"

  serialize root-node
  send-line!

  return [current-page]

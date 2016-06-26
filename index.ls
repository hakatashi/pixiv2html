require! {
  'pixiv-novel-parser': {Parser}
  'html-template-tag': html
}

module.exports = (text) ->
  parser = new Parser!
  parser.parse text
  ast = parser.tree

  ast

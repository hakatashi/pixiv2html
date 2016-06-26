pixiv2html
==========

Converts markuped text of pixiv novel into HTML.

## Install

    npm install pixiv2html

## Usage

```js
const pixiv2html = require('pixiv2html');

pixiv2html('[chapter: foo]'); //=> ['<h1>foo</h1>']
pixiv2html(`
pixiv

is
[newpage]
awesome
`); //=> ['<p>pixiv</p><br><p>is</p>', '<p>awesome</p>']
```

## API

This API exports a single function such as `pixiv2html = require('pixiv2html')`.

### `pixiv2html(text)`

* `text`: [string] Input text markuped with pixiv novel style
* **return**: [string[]] Array of pages of converted HTML

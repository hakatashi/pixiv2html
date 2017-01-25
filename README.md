pixiv2html
==========

Converts markuped text of pixiv novel into HTML.

[![Build Status][travis-image]][travis-url]
[![Coverage Status][coveralls-image]][coveralls-url]
[![Greenkeeper badge](https://badges.greenkeeper.io/hakatashi/pixiv2html.svg)](https://greenkeeper.io/)

[travis-image]: https://travis-ci.org/hakatashi/pixiv2html.svg?branch=master
[travis-url]: https://travis-ci.org/hakatashi/pixiv2html
[coveralls-image]: https://coveralls.io/repos/github/hakatashi/pixiv2html/badge.svg?branch=master
[coveralls-url]: https://coveralls.io/github/hakatashi/pixiv2html?branch=master

## Install

    npm install pixiv2html

## Usage

```js
const pixiv2html = require('pixiv2html');

pixiv2html('[chapter: foo]'); //=> ['<h1>foo</h1>']
pixiv2html(`pixiv

is
[newpage]
awesome`); //=> ['<p>pixiv</p><br><p>is</p>', '<p>awesome</p>']

pixiv2html('[chapter: <bar>]', {
    transforms: {
        chapter: title => `<h4>${title}</h4>`
    },
}); //=> ['<h4>&lt;bar&gt;</h4>']
```

## API

This API exposes a single function such as `pixiv2html = require('pixiv2html')`.

### `pixiv2html(text[, options])`

* `text`: [string] Input text markuped with pixiv novel style
* `options`: [object]
    * `options.transforms`: [object] Hash of functions to customize the output of tag conversion
        * `options.transforms.chapter`: [function(title)]
        * `options.transforms.pixivimage`: [function(illustID, pageNumber)]
        * `options.transforms.jump`: [function(pageNumber)]
    * `options.type`: [string] String to switch the output to `'html'` or `'xhtml'`. Defaults to `'html'`.
* **return**: [string[]] Array of pages of converted HTML

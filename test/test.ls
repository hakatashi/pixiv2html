require! {
  '../': pixiv2html
  chai: {expect}
}

It = global.it

describe 'basic Usage' ->
  It 'generally convert unmarkuped text through' ->
    expect pixiv2html 'Allo!' .to.equal 'Allo!'

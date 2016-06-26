require! {
  '../': pixiv2html
  chai: {expect}
}

It = global.it

# Strip indent and breakline
strip-indent = (text) -> text.replace /\n\s*/g, ''

# Util to match text with single page
single-match = (source, dest) ->
  result = pixiv2html dest

  expect result .to.have.length 1
  expect result.0 .to.equal strip-indent dest

describe 'basic Usage' ->
  It 'generally wrap unmarkuped text into paragraph' ->
    expect pixiv2html 'Allo!' .to.equal '<p>Allo!</p>'

  It 'converts empty line into <br>' ->
    single-match do
      '''

        hi


        there
      '''
      '''
        <br>
        <p>hi</p>
        <br>
        <br>
        <p>there</p>
      '''

  describe '[newpage]' ->
    It 'splits text into pages array' ->
      expect pixiv2html 'page1[newpage]page2'
      .to.deep.equal <[<p>page1</p> <p>page2</p>]>

  describe '[[rb]]' ->
    It 'converts to <ruby>' ->
      single-match do
        'pixiv[[rb: 小説 > しょうせつ]]'
        '''
          <p>
            pixiv
            <ruby>
              <rb>小説</rb>
              <rp>（</rp>
              <rt>しょうせつ</rt>
              <rp>）</rp>
            </ruby>
          </p>
        '''

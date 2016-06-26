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

describe 'Basic Usage' ->
  It 'generally wrap unmarkuped text into paragraph' ->
    expect pixiv2html 'Allo!' .to.deep.equal <[<p>Allo!</p>]>

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

  describe '[chapter]' ->
    It 'converts to <h1>' ->
      single-match do
        '[chapter: head]'
        '<h1>head</h1>'

    It 'can contain <ruby>' ->
      single-match do
        '[chapter: pixiv[[rb: 小説 > しょうせつ]]]'
        '''
          <h1>
            pixiv
            <ruby>
              <rb>小説</rb>
              <rp>（</rp>
              <rt>しょうせつ</rt>
              <rp>）</rp>
            </ruby>
          </h1>
        '''

  describe '[pixivimage]' ->
    It 'converts to <img>' ->
      single-match do
        '[pixivimage: 000001]'
        '''
          <p>
            <img src="" data-illust-id="000001">
          </p>
        '''

    It 'can contain page data' ->
      single-match do
        '[pixivimage: 000001-2]'
        '''
          <p>
            <img src="" class="pixivimage" data-illust-id="000001" data-page="2">
          </p>
        '''

  describe '[jump]' ->
    It 'converts to <a>' ->
      single-match do
        '[jump:2]'
        '<p><a href="" class="jump" data-page="2">2ページヘ</a></p>'

  describe '[[jumpuri]]' ->
    It 'converts to <a>' ->
      single-match do
        '[[jumpuri: Google > https://google.com/]]'
        '<p><a href="https://google.com/">Google</a></p>'

    It 'can contain <ruby>' ->
      single-match do
        '[[junpuri: pixiv[[rb: 小説 > しょうせつ]] > http://www.pixiv.net/novel/]]'
        '''
          <p>
            <a href="http://www.pixiv.net/novel/">
              pixiv
              <ruby>
                <rb>小説</rb>
                <rp>（</rp>
                <rt>しょうせつ</rt>
                <rp>）</rp>
              </ruby>
            </a>
          </p>
        '''

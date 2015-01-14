path   = require 'path'
assert = require 'assert'

RSSReader  = require path.resolve 'libs', 'rss-reader'

describe 'RSSReader', ->

  it 'fetch test', ->
    @timeout 10000

    reader = new RSSReader {}

    reader.fetch 'http://we.weirdmeetup.com/feed/'
    .then (entries) ->
      assert.ok entries instanceof Array
      for entry in entries
        assert.equal typeof entry.url, 'string', '"url" property not exists'
        assert.equal typeof entry.title, 'string', '"title" property not exists'
        assert.equal typeof entry.author, 'string', '"author" property not exists'

# Description:
#   RSS Entries Fetcher
#
# Author:
#   @golbin

'use strict'

request    = require 'request'
FeedParser = require 'feedparser'
Promise    = require 'bluebird'

module.exports = class RSSReader
  fetch: (url) ->
    new Promise (resolve, reject) =>
      feedparser = new FeedParser
      req = request
        uri: url
        timeout: 10000

      req.on 'error', (err) ->
        reject err

      req.on 'response', (res) ->
        stream = this
        if res.statusCode isnt 200
          return reject "statusCode: #{res.statusCode}"
        stream.pipe feedparser

      feedparser.on 'error', (err) ->
        reject err

      entries = []
      feedparser.on 'data', (chunk) =>
        entry =
          url: chunk.guid
          title: chunk.title
          author: chunk.author
          toString: ->
            s = "#{@title} - #{@url} by @#{@author}"
            return s

        entries.push entry

      feedparser.on 'end', ->
        resolve entries


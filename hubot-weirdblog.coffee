# Description:
#   Hubot WeirdMeetup Blog Reader
#
# Commands:
#   hubot blog
#
# Author:
#   @golbin

'use strict'

path      = require 'path'
_         = require 'lodash'
Promise   = require 'bluebird'
RSSReader = require path.join __dirname, '/libs/rss-reader'

BLOG_FEED_URL = 'http://we.weirdmeetup.com/feed/'

CACHE_EXPIRES = 300 * 1000# milliseconds
CACHED_TIME = 0
CACHED_ENTRIES = []

module.exports = (robot) ->
  reader = new RSSReader robot

  robot.respond /blog/i, (msg) ->
    if CACHED_ENTRIES.length > 0
      for entry in CACHED_ENTRIES.splice(0,5)
        msg.send entry.toString()
      msg.send "갱신시간: " + new Date(CACHED_TIME)

    if Date.now() > CACHED_TIME + CACHE_EXPIRES
      msg.send "글을 가져오는 중 입니다. 새 글을 보시려면 잠시 후 다시 시도해주세요."

      reader.fetch(BLOG_FEED_URL)
      .then (entries) ->
        CACHED_ENTRIES = entries
        CACHED_TIME = Date.now()
      .catch (err) ->
        msg.send "블로그 글을 가져오지 못했습니다."

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

home = ->
  $('#article_summaries').infinitescroll
    navSelector: 'nav.pagination'
    nextSelector: 'nav.pagination a[rel=next]'
    itemSelector: '#article_summaries .article_summary'

$(document).ready(home)
$(document).on('page:load', home)

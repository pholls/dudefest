# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

pluralize_characters = (num) ->
  if num is 1 
    num + ' character' 
  else 
    num + ' characters'

@character_count = (min, max, class_name) ->
  $('.char_count').keyup ->
    chars = $('.char_count').val().length
    left = max - chars
    count_class = '#' + class_name
    if chars < min
      $(count_class).text pluralize_characters(min - chars) + ' to go'
      $(count_class).css 'color', 'red'
    else if chars <= max
      $(count_class).text pluralize_characters(left) + ' left'
      $(count_class).css 'color', 'black'
    else
      $(count_class).text pluralize_characters(left * (-1)) + ' too long'
      $(count_class).css 'color', 'red'

home = ->
  $('#article_summaries').infinitescroll
    navSelector: 'nav.pagination'
    nextSelector: 'nav.pagination a[rel=next]'
    itemSelector: '#article_summaries .article_summary'

$(document).ready(home)
$(document).on('page:load', home)


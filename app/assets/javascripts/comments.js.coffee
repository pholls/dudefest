# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
comment_shit = ->
  $('.comment_reply_link').click ->
    if $(this).next().is(':visible')
      $(this).find('a').text('Reply').css 'background', 'transparent'
      $(this).next().hide()
    else
      $(this).find('a').text('Close').css 'background', '#CCCCCC'
      $(this).next().show()

$(document).ready(comment_shit)
$(document).on('page:load', comment_shit)

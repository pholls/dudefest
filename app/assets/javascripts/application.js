// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require ckeditor/ckeditor
//= require ckeditor/init
//= require_tree .
//= require turbolinks

var ready;
ready = function() { 
  $('#nav > li').hover(
    function () {
      //show its submenu
      $('a', this).addClass('selected');
      $('ul', this).show();
      $('#sub_nav').css('font-size','0');
    }, 
    function () {
      //hide its submenu
      $('a', this).removeClass('selected');
      $('ul', this).hide();
      $('#sub_nav').css('font-size','20px');
    }
  );
};

$(document).on('turbolinks:load', ready);

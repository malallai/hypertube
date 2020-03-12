// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs")
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("local-time").start()
require("iconify.min.js")

import 'bootstrap'
import 'data-confirm-modal'
import Rails from "@rails/ujs";
if (Rails.fire(document, "rails:attachBindings")) {
  Rails.start();
}
window.Rails = Rails

$(document).on("turbolinks:load", () => {
  $('[data-toggle="tooltip"]').tooltip()
  $('[data-toggle="popover"]').popover()

  $('.locale-select').on({
    click: function() {
      event.preventDefault();
      let locale = $(this).text();
      Rails.ajax({
        url: '/locale/edit',
        type: 'post',
        contentType: 'json',
        data: "locale=" + locale,
        success: function(data) {
          Turbolinks.visit('#')
        }
      });
    }
  });

  function search(append = false) {
    Rails.ajax({
      url: '/searchs',
      type: 'post',
      contentType: 'json',
      data: $('#search_movie').serialize(),
      success: function(data) {
        let container = $('#movies_container');
        if (append)
		  container.html(container.html() + data.activeElement.innerHTML);
		else
		  container.html(data.activeElement.innerHTML);
        //$('#loading').hide();
      }
    });
  }

  $('#search_movie').on({
    submit: function() {
      event.preventDefault();
      $('#page').val(1);
      search();
    }
  });

  /*
  $(window).on('load', function() {
    $('#loading').hide();
  });
  */

  $(window).scroll(function() {
	if($(window).scrollTop() + $(window).height() == $(document).height()) {
	  event.preventDefault();
	  $('#loading').show();
	  let page = parseInt($('#page').val());
	  $('#page').val(page + 1);
	  search(true);
	}
  });

  $('#send_comment').on({
    submit: function() {
      event.preventDefault();
      Rails.ajax({
        url: '/comments',
        type: 'post',
        contentType: 'json',
        data: $('#send_comment').serialize(),
        success: function(data) {
          let container = $('#comments_container');
          $('#comment').val('');
          container.html(data.activeElement.innerHTML);
        }
      });
    }
  });
});

function refreshPartial() {
  document.querySelectorAll('.dlbar').forEach(node => {
    $.ajax({
      url: "/movies/refresh_part/" + node.id.split('-').slice(1).join('-')
    });
  });
}
$(document).ready(function () {
	refreshPartial();
    setInterval(refreshPartial, 1000);
});

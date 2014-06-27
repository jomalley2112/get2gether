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
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .
//= require bootstrap-datetimepicker.min



// $(function() {
// 	//debugger;
// 	$("input#meeting_start_time").datetimepicker();
// });

// $(document).ready(function(){
//   $('[data-behaviour~=datepicker]').datetimepicker({
//     language: 'en',
//     pick12HourFormat: true,
//     pickSeconds: false
//   });
// })


var ready;
ready = function() {
    $('#datetimepicker').datetimepicker({
      language: 'en',
      pick12HourFormat: true,
      pickSeconds: false
    });
  };

  $(document).ready(ready);
  $(document).on('page:load', ready); //Strictly for Turbolinks

  function set_per_page(sel) {
  	url = updateQueryStringParameter($(location).attr('href'), "per_page", $(sel).val())
  	window.location = updateQueryStringParameter(url, "page", "1")
  }

function updateQueryStringParameter(uri, key, value) {
  var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
  var separator = uri.indexOf('?') !== -1 ? "&" : "?";
  if (uri.match(re)) {
    return uri.replace(re, '$1' + key + "=" + value + '$2');
  }
  else {
    return uri + separator + key + "=" + value;
  }
}


function clear_search() {
  frm = $("#search-form");
  $(frm).find("input#search").val("");
  $(frm).submit();
}
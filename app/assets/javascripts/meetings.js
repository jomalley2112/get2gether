/* For the Meeting form*/

$(function() {
  dis_enable_btn($("input#save_meeting_btn"));
  $("input#meeting_location").keyup(function() {
    dis_enable_btn($("input#save_meeting_btn"));
  });
  
  //For using ajax to populate the people section of the form
  /*if ($(location).attr('href').indexOf("/meetings/new") > -1 || /\/meetings\/\d*\/edit/.test($(location).attr('href'))) {
   draw_people_html(); 
  }*/
})

function dis_enable_btn(btn) {
  if ($("input#meeting_location").val() == "") {
    btn.attr("disabled", "disabled");
  } else {
    btn.removeAttr('disabled');
  }
}

function draw_people_html() {
  $.ajax({url:"/people/index_no_layout?per_page=15",success:function(result){
    //debugger;
    $("td#people").html(result);
  }});
}

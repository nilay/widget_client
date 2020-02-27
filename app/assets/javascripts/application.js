// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require_tree .


$(document).ready(function(){
  $('.login_button').click(function(){        
    $('#signupModal').modal('hide');
    $('#loginModal').modal('show');
  });
    
  $('.signup_button').click(function(){          
    $('#loginModal').modal('hide');
    $('#signupModal').modal('show');
  });

  $("#search_button").click(function(){
		var val = $("#search_input").val()
		$.ajax({
			type: "get",
			url: "/",
			dataType: "script",
			data: {val: val}
		});
  })

  $("#search_form").submit(function(e){
    e.preventDefault();
    var val = $("#search_input").val()
    $.ajax({
      type: "get",
      url: "/",
      dataType: "script",
      data: {val: val}
    });
  })

  $("#search_form_user").submit(function(e){
    e.preventDefault();
    debugger;
    var id = $("#user_id").data('id')
    var val = $("#search_input_user").val()
    $.ajax({
      type: "get",
      url: "/users/"+ id+ "/widgets",
      dataType: "script",
      data: {val: val}
    });
  })
      
});
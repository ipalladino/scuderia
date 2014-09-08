$(function(){
if(App.page != undefined){if(App.page=="savedSearches"){
  $(".notify_me").live("change", function(e){
    console.log(e.currentTarget.value);
    $.ajax({
          url: "/saved_searches/toggle",
          data: {"id" : e.currentTarget.value},
          success: function(result){
            if(result) {
              $(e.currentTarget).parent().find("#notify_me_status").html("Enabled!");
              $(e.currentTarget).parent().find("#notify_me_status").css({"color": "green", "position":"relative" , "top":"2px"});
            } else {
              $(e.currentTarget).parent().find("#notify_me_status").html("Disabled");
              $(e.currentTarget).parent().find("#notify_me_status").css({"color": "red", "position":"relative" , "top":"2px"});
            }
          }
    });
    console.log("changed!");
  });
}}
});

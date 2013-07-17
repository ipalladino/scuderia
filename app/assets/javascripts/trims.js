$('#year_selection').live('change', function(){
  $.ajax({
    url: "trims/year_selection",
    type: "GET",
    data: {'year' : $('#year_selection option:selected').val() }
  })
});

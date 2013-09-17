$('#ferrari_year_id').live('change', function(){
  $.ajax({
    url: "/ferraris/ferraris/year_selection",
    type: "GET",
    data: {'year' : $('#ferrari_year_id option:selected').val() }
  })
});
/*
$('#ferrari_car_model_id').live('change', function(){
  $.ajax({
    url: "/ferraris/ferraris/model_selection",
    type: "GET",
    data: {
        'year'  : $('#ferrari_year_id option:selected').val(),
        'model' : $('#ferrari_car_model_id option:selected').val()
    }
  })
});
*/
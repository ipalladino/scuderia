$('#ferrari_year_id').live('change', function(){
  $.ajax({
    url: "/ferraris/ferraris/year_selection",
    type: "GET",
    data: {'year' : $('#ferrari_year_id option:selected').val() }
  })
});


$(function() {
  $("#year-fr").on("focus", function(e) {
      if(e.currentTarget.value == "Year Fr")
        e.currentTarget.value = "";
  })
  $("#year-fr").on("blur", function(e) {
      if(e.currentTarget.value == "")
        e.currentTarget.value = "Year Fr";
  })

  $("#year-to").on("focus", function(e) {
      if(e.currentTarget.value == "Year To")
          e.currentTarget.value = "";
  })
  $("#year-to").on("blur", function(e) {
      if(e.currentTarget.value == "")
        e.currentTarget.value = "Year To";
  })

  //PRICE
  $("#price-fr").on("focus", function(e) {
      if(e.currentTarget.value == "Price Fr")
          e.currentTarget.value = "";
  })
  $("#price-fr").on("blur", function(e) {
        if(e.currentTarget.value == "")
            e.currentTarget.value = "Price Fr";
  })
  $("#price-to").on("focus", function(e) {
      if(e.currentTarget.value == "Price To")
          e.currentTarget.value = "";
  })
  $("#price-to").on("blur", function(e) {
      if(e.currentTarget.value == "")
          e.currentTarget.value = "Price To";
  })

  //KEYWORDS
  $("#keywords").on("focus", function(e) {
        if(e.currentTarget.value == "Keywords")
            e.currentTarget.value = "";
  })
  $("#keywords").on("blur", function(e) {
          if(e.currentTarget.value == "")
              e.currentTarget.value = "Keywords";
  })

  $("#dropdown-models").on("click", function(){
      console.log("dropdown-models click")
      $("#model").autocomplete("search", "");
  });

  $("#year-fr").autocomplete({
      /* snip */
      source: years,
      select: function(event, ui) {
          event.preventDefault();
          $("#year-fr").val(ui.item.label);
          $("#year-fr-h").val(ui.item.id);
      },
      focus: function(event, ui) {
          event.preventDefault();
          $("#year-fr").val(ui.item.label);
      }
  });


  $("#year-to").autocomplete({
      /* snip */
      source: years,
      select: function(event, ui) {
          event.preventDefault();
          $("#year-to").val(ui.item.label);
          $("#year-to-h").val(ui.item.id);
      },
      focus: function(event, ui) {
          event.preventDefault();
          $("#year-to").val(ui.item.label);
      }
  });

  var checkAndFilterModels = function(e) {
      var syea_fr = $("#year-fr").attr("value"),
          syea_to = $("#year-to").attr("value");

      var year_fr = Number($("#year-fr").attr("value")),
          year_to = Number($("#year-to").attr("value"));

      var blank_fr = (syea_fr == "" || syea_fr == "Year Fr")? true : false;
      var blank_to = (syea_to == "" || syea_to == "Year To")? true : false;

      if((year_fr >= Number(years[0].label) && year_fr <= year_to && year_to <= Number(years[years.length-1].label)) ||
          ((blank_fr && !blank_to) && year_to <= Number(years[years.length-1].label)) ||
          ((blank_to && !blank_fr) && year_fr >= Number(years[0].label))
      ) {
          $("#errorMessage").css("display", "none");
          e.preventDefault();
          $.ajax({
            type: "POST",
            url: "/filter_car_models",
            data: { year_fr: $("#year-fr").attr("value"), year_to: $("#year-to").attr("value") }
          })
            .done(function(response) {
                $("#model").autocomplete({
                    /* snip */
                        minLength: 0,
                        source: response,
                        select: function(event, ui) {
                            event.preventDefault();
                            $("#model").val(ui.item.label);
                            $("#model-h").val(ui.item.id);
                        },
                        focus: function(event, ui) {
                            event.preventDefault();
                            $("#model").val(ui.item.label);
                        }
                });
          });
      } else {
          $("#errorMessage").css("display", "block");
      }
  }

  $("#year-fr").on("blur", checkAndFilterModels);
  $("#year-to").on("blur", checkAndFilterModels);
});
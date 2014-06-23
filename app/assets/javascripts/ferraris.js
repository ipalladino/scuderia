var car_models = [];
        
$('#ferrari_year_id').live('change', function(){
  $.ajax({
    url: "/ferraris/ferraris/year_selection",
    type: "GET",
    data: {'year' : $('#ferrari_year_id option:selected').val() }
  })
});


$(function() {
  if(App.page != undefined){ 
  if(App.page=="ferraris"){
  console.log("PAGE: "+App.page);
  $("#year-fr").on("focus", function(e) {
      if(e.currentTarget.value == "Year From")
        e.currentTarget.value = "";
  })
  $("#year-fr").on("blur", function(e) {
      if(e.currentTarget.value == "") {
          e.currentTarget.value = "Year From";
          $("#yrfr_id").val("");
      }
        
  })

  $("#year-to").on("focus", function(e) {
      if(e.currentTarget.value == "Year To")
          e.currentTarget.value = "";
  })
  $("#year-to").on("blur", function(e) {
      if(e.currentTarget.value == "") {
        e.currentTarget.value = "Year To";
        $("#yrto_id").val("");
      }
  })

  //model
  $("#model").on("focus", function(e) {
      if(e.currentTarget.value == "Model")
        e.currentTarget.value = "";
  })
  $("#model").on("blur", function(e) {
      if(e.currentTarget.value == "")
        e.currentTarget.value = "Model";
  })
  //PRICE
  $("#prce_fr").on("focus", function(e) {
      if(e.currentTarget.value == "Price From")
          e.currentTarget.value = "";
  })
  $("#prce_fr").on("blur", function(e) {
        if(e.currentTarget.value == "")
            e.currentTarget.value = "Price From";
  })
  $("#prce_to").on("focus", function(e) {
      if(e.currentTarget.value == "Price To")
          e.currentTarget.value = "";
  })
  $("#prce_to").on("blur", function(e) {
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
      $("#model").autocomplete("search", "");
  });

  $("#year-fr").autocomplete({
      /* snip */
      source: years,
      select: function(event, ui) {
          event.preventDefault();
          $("#year-fr").val(ui.item.label);
      },
      focus: function(event, ui) {
          event.preventDefault();
          $("#year-fr").val(ui.item.label);
      },
      close : function(event, ui) {
          event.preventDefault();
          var yrfr = $("#year-fr").val();
          for(i=0;i<years.length;i++) {
              if(years[i].label == yrfr) {
                  $("#yrfr_id").val(years[i].value);
                  break;
              }
              $("#yrfr_id").val("");
          }
      }
  });
  
  $("#year-to").autocomplete({
      /* snip */
      source: years,
      select: function(event, ui) {
          event.preventDefault();
          $("#year-to").val(ui.item.label);
      },
      focus: function(event, ui) {
          event.preventDefault();
          $("#year-to").val(ui.item.label);
      },
      close : function(event, ui) {
          event.preventDefault();
          var yrfr = $("#year-to").val();
          for(i=0;i<years.length;i++) {
              if(years[i].label == yrfr) {
                  $("#yrto_id").val(years[i].value);
                  break;
              }
              $("#yrto_id").val("");
          }
      }
  });

  var checkAndFilterModels = function(e) {
      var syea_fr = $("#year-fr").attr("value"),
          syea_to = $("#year-to").attr("value");

      var year_fr = Number($("#year-fr").attr("value")),
          year_to = Number($("#year-to").attr("value"));

      var blank_fr = (syea_fr == "" || syea_fr == "Year From")? true : false;
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
                car_models = response;
                $("#model").autocomplete({
                    /* snip */
                        minLength: 0,
                        source: response,
                        select: function(event, ui) {
                            event.preventDefault();
                            $("#model").val(ui.item.label);
                        },
                        focus: function(event, ui) {
                            event.preventDefault();
                            $("#model").val(ui.item.label);
                        },
                        close: function(event, ui) {
                            event.preventDefault();
                            var yrfr = $("#model").val();
                            for(i=0;i<car_models.length;i++) {
                                if(car_models[i].label == yrfr) {
                                    $("#modl_id").val(car_models[i].value);
                                    break;
                                }
                                $("#modl_id").val("");
                            }
                        }
                });
          });
      } else {
          $("#errorMessage").css("display", "block");
      }
  }
  
  $("#save_search").on("click", function() {
      App.savedSearch.save();
  });
  
  $("#year-fr").on("blur", checkAndFilterModels);
  $("#year-to").on("blur", checkAndFilterModels);
  $("#submit").on("click", function() {
      console.log("Submit");
      var model = $("#model").val().trim();
      if(model == "" || model == "Model") {
          model = "";
      }
      var keywords = $("#keywords").val().trim();
      if(keywords == "" || keywords == "Keywords") {
          keywords = "";
      }
      
      var reg = /^\d+$/;
      
      price_to = (reg.test($("#prce_to").val()))? $("#prce_to").val() : price_to = "";
      price_fr = (reg.test($("#prce_fr").val()))? $("#prce_fr").val() : price_fr = "";
      year_fr = (reg.test($("#year-fr").val()))? $("#year-fr").val() : "" ;
      year_to = (reg.test($("#year-to").val()))? $("#year-to").val() : "" ;
      
      var query = {
          prce_to : price_to,
          prce_fr : price_fr,
          year_fr : year_fr,
          year_to : year_to,
          car_model : model,
          keywords : keywords
      }
      
      App.savedSearch.set(query);
      
      App.carsColl.fetch({reset: true, data: query})
  });
  
  
  App.ferrarisModel = new App.FerrarisModel();
  App.carsView = new App.CarsView({el : $('#ferraris-bb-list'), model: App.ferrarisModel});
  
  var QueryString = function () {
    // This function is anonymous, is executed immediately and 
    // the return value is assigned to QueryString!
    var query_string = {};
    var query = window.location.search.substring(1);
    var vars = query.split("&");
    for (var i=0;i<vars.length;i++) {
      var pair = vars[i].split("=");
      	// If first entry with this name
      if (typeof query_string[pair[0]] === "undefined") {
        query_string[pair[0]] = pair[1];
      	// If second entry with this name
      } else if (typeof query_string[pair[0]] === "string") {
        var arr = [ query_string[pair[0]], pair[1] ];
        query_string[pair[0]] = arr;
      	// If third or later entry with this name
      } else {
        query_string[pair[0]].push(pair[1]);
      }
    } 
      return query_string;
  } ();
  
  if(Object.keys(QueryString).length === 0) {
      App.ferrarisModel.loadCollection();  
  } else {
      App.ferrarisModel.loadCollection(QueryString);
      //year_to=1965&year_fr=1950&modelstr=&prce_fr=&prce_to=&keywords=
      
      if(QueryString.year_fr != "")
        $("#year-fr").val(QueryString.year_fr);
      if(QueryString.year_to != "")
        $("#year-to").val(QueryString.year_to);
      if(QueryString.prce_fr != "")
        $("#prce_fr").val(QueryString.prce_fr);
      if(QueryString.prce_to != "")
        $("#prce_to").val(QueryString.prce_to);
      if(QueryString.modelstr != "")
        $("#modelstr").val(QueryString.modelstr);
      if(QueryString.keywords != "")
        $("#keywords").val(QueryString.keywords);
  }
  
  
  App.savedSearch = new App.SavedSearch();
}}
});
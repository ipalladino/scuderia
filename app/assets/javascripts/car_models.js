$(function() {
if(App.page != undefined){ if(App.page=="collection"){
console.log("PAGE: "+App.page);
var checkAndFilterModels = function(e) {
      var yearfr = $("#year-fr").val().trim();
      var yearto = $("#year-to").val().trim();
      if(yearfr.match(/^\d{4}$/) != null && yearto.match(/^\d{4}$/) && Number(yearfr) <= Number(yearto)) {
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
                            $("#modl_id").val(ui.item.value);
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
  $("#model").on("focus", function(e) {
        if(e.currentTarget.value == "Model")
          e.currentTarget.value = "";
    })
    $("#model").on("blur", function(e) {
        if(e.currentTarget.value == "")
          e.currentTarget.value = "Model";
    })
  
  $("#year-fr").on("focus", function(e) {
        if(e.currentTarget.value == "Year Fr")
          e.currentTarget.value = "";
    })
    $("#year-fr").on("blur", function(e) {
        if(e.currentTarget.value == "") {
            e.currentTarget.value = "Year Fr";
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
    
    $("#dropdown-models").on("click", function(){
        $("#model").autocomplete("search", "");
    });

  $("#year-fr").on("blur", checkAndFilterModels);
  $("#year-to").on("blur", checkAndFilterModels);
    
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
  });


    App.ModelsColl = Backbone.Collection.extend({
        url : "/model_search",
    });
    
    App.WrapModCol = Backbone.Model.extend({
        defaults : {
            howmany : 35,
            ttlpgs : 0,
            page : 0
        },
        initialize: function(){
            this.collection = new App.ModelsColl();
            this.collection.on("reset", this.onLoadCollection, this);
        },
        
        loadCollection: function(options) {
            if(options== undefined) {
                options = {};
            }
            this.set("page", 0, {silent:true});
            this.collection.fetch({data : options, reset : true});
        },
        
        onLoadCollection: function(result) {
            this.set("ttlpgs",this.collection.length/this.get("howmany"));
            this.trigger("loaded");
        } 
    });
    
    App.ModelsView = Backbone.View.extend({
        template : JST['collection_template'],
        el: $('#collection-list'),
        events: {
            "click .dopage"     : "setPage",
            "click .doright"    : "right",
            "click .doleft"     : "left",
        },
        initialize: function(){
            this.model.on("loaded", this.render, this);
            this.model.on("change:page", this.render, this);
            $("#search").on("click", function(){
                var yearfr = $("#year-fr").val().trim();
                var yearto = $("#year-to").val().trim();
                var modelo = $("#model").val().trim();
                
                if(yearfr.match(/^\d{4}$/) != null && yearto.match(/^\d{4}$/) && Number(yearfr) <= Number(yearto)) {
                    if(modelo != "Model" && modelo != "") {
                        App.wrapModCol.loadCollection({from:yearfr,to:yearto, model: modelo});
                    } else {
                        App.wrapModCol.loadCollection({from:yearfr,to:yearto});
                    }
                } else {
                    if(modelo != "Model" && modelo != "") {
                        App.wrapModCol.loadCollection({model: modelo});
                    }
                }
            });
            
        },

        render: function(){
            $(this.el).html("");
            var page = this.model.get("page");
            var hwmy = this.model.get("howmany");
            var coll = this.model.collection.toJSON();
            var boti = page*hwmy;
            var topi = page*hwmy+hwmy;
            
            var data = {
                items: coll.slice(boti,topi),
                total: this.model.get("ttlpgs"),
                fr: boti,
                to: topi,
                page : page
            };
            var html = this.template(data);
            $(this.el).html(html);
        },
        setPage : function (e) {
            var page = e.currentTarget.dataset.page;
            this.model.set("page",Number(page));
        },
        left : function () { 
            if(this.model.get("page") > 0) {
                this.model.set("page", this.model.get("page")-1);
            }
        },
        right : function () {
            if(this.model.get("page") < this.model.get("ttlpgs")-1) {
                this.model.set("page", this.model.get("page")+1);
            }
        }
    });
    
    App.wrapModCol = new App.WrapModCol();
    App.modelsView = new App.ModelsView({model:App.wrapModCol});
    App.wrapModCol.loadCollection();
}}
});

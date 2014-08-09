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
            "mouseenter .ferrari-model-item"    : "mouseOver",
            "mouseleave .ferrari-model-item"    : "mouseOut",
            "click .ferrari-model-item"         : "navigateToModel"
        },
        initialize: function(){
            this.model.on("change:page", this.render, this);
            //this.model.on("loaded", this.render, this);
            var scope = this;
            
            var searchHandler = function(){
                console.log("#search.on:click");
                var yearfr = $("#year-fr").val().trim();
                var yearto = $("#year-to").val().trim();
                var modelo = $("#model").val().trim();
                
                $("#collection-list").html('<div class="span12 ajax-loader" id="loader"><span><img src="/assets/ajax-loader.gif" /></span></div>');
                
                if(yearfr.match(/^\d{4}$/) != null && yearto.match(/^\d{4}$/) && Number(yearfr) <= Number(yearto)) {
                    if(modelo != "Model" && modelo != "") {
                        scope.model.once("loaded", scope.render, scope);
                        App.wrapModCol.loadCollection({from:yearfr,to:yearto, model: modelo});
                    } else {
                        scope.model.once("loaded", scope.render, scope);
                        App.wrapModCol.loadCollection({from:yearfr,to:yearto});
                    }
                } else {
                    if(modelo != "Model" && modelo != "") {
                        scope.model.once("loaded", scope.render, scope);
                        App.wrapModCol.loadCollection({model: modelo});
                    }
                }
            }
            
            $("input").keyup(function (e) {
                if (e.keyCode == 13) {
                    searchHandler();
                    App.router.navigate("car_models");
                }
            });
            $("#search").on("click", searchHandler);
            
        },

        render: function(){
            $(this.el).html("");
            var page = this.model.get("page"),
                hwmy = this.model.get("howmany"),
                coll = this.model.collection.toJSON(),
                coll = coll.reverse(),
                boti = page*hwmy,
                topi = page*hwmy+hwmy;
            
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
        
        navigateToModel : function (e) {
            console.log("ModelsView.navigateToModel");
            e.preventDefault();
            var id = e.currentTarget.dataset.id;
            el = e.currentTarget;
            var spinner = new Spinner({
                color : '#f0f0f0'
            }).spin();
            spinner.el.style.position = "absolute";
            el.appendChild(spinner.el);
            
            App.router.navigate("model/"+id, {trigger:true});
        },
        
        mouseOver : function (e) {
            console.log("ModelsView.mouseOver");
            console.log(e);
            $(e.currentTarget).find(".ferrari-model-overlay").css("display", "block");
        },
        
        mouseOut : function (e) {
            console.log("ModelsView.mouseOver");
            console.log(e);
            $(e.currentTarget).find(".ferrari-model-overlay").css("display","none");
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
    
    App.Router = Backbone.Router.extend({
        routes: {
            "start"                       : "start",
            "car_models"                  : "collectionRender",
            "model/:id"                   : "showFerrariModel",    // #help
          },
          
          start : function() {
              App.wrapModCol = new App.WrapModCol();
              App.wrapModCol.once("loaded", function(){
                    console.log("App.Router App.wrapModCol, once:loaded");
                    App.router.collectionRender();
                }, this);
              App.modelsView = new App.ModelsView({model:App.wrapModCol});
              App.wrapModCol.loadCollection();
          },
          
          collectionRender : function () {
              console.log("Router.collectionRender");
              if(App.modelsView == undefined) {
                  //this.start();
              } else {
                  App.modelsView.render();
              }
          },

          showFerrariModel: function(id) {
              console.log("Router.showFerrariModel");
              $.ajax({
                  url: "/car_models/"+id,
                  type: "GET",
                  data: {'format' : 'js' }
              });
          }
    })
    
    App.router = new App.Router();
    Backbone.history.start()
    App.router.start();
}}
});

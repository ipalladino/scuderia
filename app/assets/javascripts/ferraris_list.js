var App = {};

App.CarsView = Backbone.View.extend({
    template : JST['ferrari_list_item_template'],
    events: {
        "change #sort"            : "sort",
        "mouseenter  .ferrari-line" : "mouseOver",
        "mouseleave  .ferrari-line" : "mouseOut",
        "click .ferrari-line" : "navigateFerrari"
    },
    initialize: function(){
        this.model.on("loaded", this.render, this);
    },

    render: function(){
        var items = this.model.collection.toJSON();
        var data = {
            items : items
        }
        var html = this.template(data);
        $(this.el).html(html);  
      
        $('#twitterbtn-link,#facebookbtn-link').click(function(event) {
            var width  = 575,
                height = 400,
                left   = ($(window).width()  - width)  / 2,
                top    = ($(window).height() - height) / 2,
                url    = this.href,
                opts   = 'status=1' +
                         ',width='  + width  +
                         ',height=' + height +
                         ',top='    + top    +
                         ',left='   + left;

                window.open(event.currentTarget.attributes[2].nodeValue, 'twitter', opts);

            return false;
        });
        document.querySelector("#sort").selectedIndex = this.model.get("selectedSelectIndex");
    },
    
    navigateFerrari : function (e) {
        console.log("CarsView.navigateFerrari");
        //e.preventDefault();
        var id = e.currentTarget.dataset.id;
        var url = 'http://'+window.location.host+'/ferraris/'+id;
        window.location.href = url;
    },
    
    mouseOut : function (e) {
        console.log("CarsView.mouseOut");
        $(e.currentTarget).removeClass("ferrari-line-hover");
        $(e.currentTarget).find(".ferrari-list-details").removeClass("ferrari-line-hover");
    },
    
    mouseOver : function (e) {
        console.log("CarsView.mouseOver");
        $(e.currentTarget).addClass("ferrari-line-hover");
        $(e.currentTarget).find(".ferrari-list-details").addClass("ferrari-line-hover");
    },
    
    sort : function (e) {
        console.log("CarsView.class name.sort: "+e.currentTarget.value);
        console.log(e);
        this.model.set("selectedSelectIndex", e.currentTarget.selectedIndex);
        
        
        if($("#prce_to").length > 0) {
            console.log("Submit");
            var model = $("#model").val().trim();
            if(model == "" || model == "Model") {
              model = "";
            }

            var reg = /^\d+$/;

            var sort_by = e.currentTarget.value;
            price_to = (reg.test($("#prce_to").val()))? $("#prce_to").val() : price_to = "";
            price_fr = (reg.test($("#prce_fr").val()))? $("#prce_fr").val() : price_fr = "";
            year_fr = (reg.test($("#year-fr").val()))? $("#year-fr").val() : "" ;
            year_to = (reg.test($("#year-to").val()))? $("#year-to").val() : "" ;
            keywords = $("#keywords").val().trim();

            this.model.loadCollection({
                price_to : price_to,
                price_fr : price_fr,
                year_fr : year_fr,
                year_to : year_to,
                model : model,
                keywords : keywords,
                sort_by : sort_by
            });
            
        } else {
            var sort_by = e.currentTarget.value;

            this.model.loadCollection({
                  sort_by : sort_by
            });
        }
    },
});

App.FerrarisModel = Backbone.Model.extend({
    defaults : {
        selectedSelectIndex : 0
    },
    initialize: function(){
        this.collection = App.carsColl = new App.CarsColl();
        this.collection.on("reset", this.onLoadCollection, this);
    },
    
    loadCollection: function(options) {
        if(options== undefined) {
            options = {};
        }
        
        this.collection.fetch({data : options, reset : true});
    },
    
    onLoadCollection : function () {
        this.trigger("loaded");
    }
});

App.CarsColl = Backbone.Collection.extend({
      url : "/basic_search"
});

App.SavedSearch = Backbone.Model.extend({
    defaults : {
        price_to : "",
        price_fr : "",
        year_fr : "",
        year_to : "",
        car_model : "",
        keywords : ""
    }, 
    urlRoot : '/saved_searches'
});
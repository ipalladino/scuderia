var App = {};

App.CarsView = Backbone.View.extend({
    template : JST['ferrari_list_item_template'],
    events: {
        "change #sort"     : "sort"
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
    
    sort : function (e) {
        console.log("CarsView.class name.sort: "+e.currentTarget.value);
        console.log(e);
        this.model.set("selectedSelectIndex", e.currentTarget.selectedIndex);
        
        
        if($("#prce_to").length > 0) {
            var model = $("#modl_id").val().trim();
            if(model == "" || model == "Model") {
                model = "";
            }
            
            var price_to = ($("#prce_to").val() != "Price To")? $("#prce_to").val() : price_to = "";
            var price_fr = ($("#prce_fr").val() != "Price Fr")? $("#prce_fr").val() : price_fr = "";
            var yrfr_id = $("#yrfr_id").val();
            var yrto_id = $("#yrto_id").val();
            var sort_by = e.currentTarget.value;

            this.model.loadCollection({
                  prce_to : price_to,
                  prce_fr : price_fr,
                  yrfr_id : yrfr_id,
                  yrto_id : yrto_id,
                  modl_id : model,
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
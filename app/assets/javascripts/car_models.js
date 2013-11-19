$(function() {
if(App.page != undefined){ if(App.page=="collection"){
console.log("PAGE: "+App.page);

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
                if(yearfr.match(/^\d{4}$/) != null && yearto.match(/^\d{4}$/) && Number(yearfr) <= Number(yearto)) {
                    App.wrapModCol.loadCollection({from:yearfr,to:yearto});
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

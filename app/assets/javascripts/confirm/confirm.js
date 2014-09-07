$(function(){
console.log("hello confirm");
if(App.page == "planSelect") {

App.Plan = Backbone.Model.extend({
    defaults : {
        "prices" : [250, 150, 90],
        "selected_plan" : 0
    },
    initialize: function(){
    },
    currentPrice : function() {
      return this.get("prices")[this.get("selected_plan")];
    }
});

App.PlanView = Backbone.View.extend({
    el : "#confirm-icons",
    events : {
        "click .confirm-icon-container>i" : "selectPlan"
    },
    initialize : function(){
        this.model.on("change:selected_plan", this.changeSelectedPlan, this);
        this.changeSelectedPlan();
    },
    selectPlan : function(e){
        var id = e.currentTarget.dataset.id;
        this.model.set("selected_plan", Number(id));
    },
    changeSelectedPlan : function(ev) {
        $(this.el).find(".selected").removeClass("selected")
        var id = this.model.get("selected_plan");
        $($(this.el).find("i")[id]).addClass("selected");

        $("#publish_setting").val(id);

        $("#total-value").html(this.model.get("prices")[id]+".00");
    }
});

App.PromoCode = Backbone.Model.extend({
  default : {
    "code" : undefined
  },
  checkPromoCode :function(code){
    $.ajax({
          url: "/promo_codes/search",
          data: {"code" : code},
          success: $.proxy(this.verifyPromoCode, this)
    });
  },
  verifyPromoCode : function(result){
    if(result){
      if(result.length == 1) {
        this.set(result[0]);
        this.trigger("promocodeverified")
        return true;
      }
    }
    this.set("discount_type", 1);
    this.trigger("promocodenotverified")
    return false;
  }
});

App.PromoCodeView = Backbone.View.extend({
    el : "#promo-column",
    events : {
        "click #process-promo" : "checkPromoCode"
    },
    initialize : function(){
        this.model.on("promocodeverified", this.updateView, this);
        this.model.on("promocodenotverified", this.updateView, this);
    },
    checkPromoCode : function(){
        console.log("checkPromoCode");
        var code = $("#promo_code").val();
        this.model.checkPromoCode(code);
    },
    updateView : function() {
        var newTotal = plan.currentPrice();
        newTotal = newTotal*this.model.get("discount_type");

        $("#total-value").html(newTotal+".00")
    }
});


var plan = new App.Plan();
var planView = new App.PlanView({model : plan});

var promoCode = new App.PromoCode();
var promoCodeView = new App.PromoCodeView({model : promoCode});

}});

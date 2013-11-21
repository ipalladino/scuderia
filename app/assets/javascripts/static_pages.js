$( document ).ready(function() {
  // Handler for .ready() called.
  if(App.page != undefined) { 
      if(App.page=="homepage") {
          App.ferrarisModel = new App.FerrarisModel();
          App.carsView = new App.CarsView({el : $('#forsale-homepage'), model: App.ferrarisModel});
          App.ferrarisModel.loadCollection();
      }
  }
});
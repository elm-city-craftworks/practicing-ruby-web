Save = {
  init: function(){
    jQuery('form[data-track-changes=true] :input').
      keydown(Save.change).change(Save.change);

    jQuery('form[data-track-changes=true]').submit(function(e){
      jQuery('*[data-changed=true]').attr('data-changed', false);
    });

    window.onbeforeunload = Save.beforeUnload;
  },
  beforeUnload: function(){
    if(Save.changesMade()) return "You have unsaved changes.";
  },
  changesMade: function(){
    return (jQuery('*[data-changed=true]').length > 0)
  },
  change: function(){
    jQuery(this).attr('data-changed', true);
  }

};

jQuery(function() { Save.init(); });
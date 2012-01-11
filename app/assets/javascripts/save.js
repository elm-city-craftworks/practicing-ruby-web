/*
* save.js
* Track changes in a form and display a warning if they haven't been submitted
*
* Usage:
* Add 'data-track-changes=true' to any form which you want to track changes
*
*   <form data-track-changes=true> ... </form>
*/

Save = {
  init: function(){

    // Track keydown so changes are tracked immediately in
    // textarea and input[type=text] elements, and change for select
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
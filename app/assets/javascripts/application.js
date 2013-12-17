//= require jquery
//= require jquery_ujs
//= require md_preview
//= require jquery.elastic
//= require parsley
//= require_tree '../../../vendor/assets/javascripts'
//= require_self
//= require_tree .

// Setup the PR [Practicing Ruby] Namespace
var PR = PR ? PR : new Object();

PR.setupNamespace = function(namespace){
	if(PR[namespace] == undefined)
		PR[namespace] = {}
}

// Facebox Assets
$.facebox.settings.closeImage   = '/assets/facebox/closelabel.png';
$.facebox.settings.loadingImage = '/assets/facebox/loading.gif';

PR.immediate = function(){
  $('a[rel=tooltip]').tooltip();
  $('.bigtext').each(function() {
    var box      = $(this)
    var fontsize = parseInt(box.css('font-size'));
    box.bigtext({maxfontsize: fontsize});
  });
};

//= require jquery
//= require jquery_ujs
//= require_self
//= require_tree .

// Setup the PR [Practicing Ruby] Namespace

var PR = PR ? PR : new Object();

PR.setupNamespace = function(namespace){
	if(PR[namespace] == undefined)
		PR[namespace] = {}
}

jQuery(function(){
  if(PR.Preview) PR.Preview.init();
  $('textarea').elastic();
});
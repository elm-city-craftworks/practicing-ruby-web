//= require jquery
//= require jquery_ujs
//= require md_preview
//= require jquery.elastic
//= require_tree '../../../vendor/assets/javascripts'
//= require_self
//= require_tree .

// Setup the PR [Practicing Ruby] Namespace

var PR = PR ? PR : new Object();

PR.setupNamespace = function(namespace){
	if(PR[namespace] == undefined)
		PR[namespace] = {}
}

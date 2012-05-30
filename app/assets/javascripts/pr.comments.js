// PR.Comments

PR.setupNamespace("Comments");

PR.Comments.init = function(commentsPath){
  $('.comment a.edit').click(function(e){
    $(e.currentTarget).parents('.comment').children('.content').
    trigger('edit');
    e.preventDefault();
  });

  $('.comment .content a').live('click', function(e){
    window.open(e.target.href);
    return false;
  });

  $('.comment[data-editable=true]').each(function(i,el){
    id = $(el).attr('data-id');

    $(el).children(".content").click(function(e){
      if (e.target.tagName != "A")
        $(e.target).trigger('edit');
    }).bind('jeditable.editing', function(){
      MdPreview.buildPreviewTab($(this));
      $(this).parents('div.comment').children('div.header').hide();
    }).bind('jeditable.reset', function(){
      // TODO: DRY up this code
      PR.Comments.teardownPreview(this);
      $(this).parents('div.comment').children('div.header').show();
    });

    $(el).children(".content").editable(commentsPath + id, {
      type:        'textarea',
      method:      'PUT',
      indicator:   'Saving ...',
      cancel:      'Cancel',
      submit:      'Save',
      loadurl:     commentsPath + id,
      width:       '98%',
      event:       'edit',
      onblur:      'ignore',
      clicktoedit: false,
      callback:    function(value, settings) {
        // TODO: DRY up this code
        PR.Comments.teardownPreview(this);
        $(this).parents('div.comment').children('div.header').show();
      }
    });
  });

  $('form.new_comment').submit(function(e){
    $('input[type=submit]', this).attr('disabled', 'disabled');
  })

}

PR.Comments.teardownPreview = function(content){
  var content          = $(content);
  var previewContainer = content.parents('div.markdown-preview');
  var commentContainer = content.parents('div.comment');

  content.appendTo(commentContainer);
  previewContainer.remove();
}

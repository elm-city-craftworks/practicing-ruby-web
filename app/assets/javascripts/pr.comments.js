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
      var tabContainer = $(this).parents('div.comment').find('div.tab-container');
      tabContainer.append(
        '<button type="submit">Save</button>' +
        '<button type="cancel">Cancel</button>');

      $.each(['submit', 'cancel'], function(i, type){
        tabContainer.children('button[type=' + type + ']').click(function(){
          tabContainer.find('form button[type=' + type + ']').click();
        });
      });

      $(this).parents('div.comment').find('form button').hide();

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

  // Use custom markdown parsing for comments
  // TODO: Fix this in MdPreview so it is easy to override the URL
  //
  MdPreview.convertMarkdown = function(tab) {
    var text = tab.find('textarea').val();
    var previewTab = tab.filter('.tab-content.preview');

    previewTab.html("<p>Loading ...</p>");

    $.post("/comments/parse.text", { text: text },
      function(data){
        previewTab.html(data);
      }
    );
  }

}

PR.Comments.teardownPreview = function(content){
  var content          = $(content);
  var previewContainer = content.parents('div.markdown-preview');
  var commentContainer = content.parents('div.comment');

  content.appendTo(commentContainer);
  previewContainer.remove();
}

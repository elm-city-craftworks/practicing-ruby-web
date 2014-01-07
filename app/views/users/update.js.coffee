unless <%= @user.errors.any? %>
  $.facebox "<p>Email updated and confirmation sent. Thanks!</p>"
else
  alert "<%= @user.errors.full_messages.join(', ') %>"

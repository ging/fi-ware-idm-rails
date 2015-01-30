Deface::Override.new(:virtual_path => "settings/_index", 
                     :name => "remove_account_settings_start_if", 
                     :insert_before => "code[erb-loud]:contains('devise/registrations/edit_user')",
                     :text => "<% if !current_user.ext_idp? %>")

Deface::Override.new(:virtual_path => "settings/_index", 
                     :name => "remove_account_settings_end_if", 
                     :insert_before => "code[erb-loud]:contains('render partial: \"language\"')",
                     :text => "<% end %>")
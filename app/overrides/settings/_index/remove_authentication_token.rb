Deface::Override.new(:virtual_path => "settings/_index", 
                     :name => "remove_authentication_token", 
                     :remove => "code[erb-silent]:contains('authentication_token')", 
                     :closing_selector => "code[erb-silent]:contains('end')")

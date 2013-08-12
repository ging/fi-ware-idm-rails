Deface::Override.new virtual_path: 'site/clients/show',
                     name: 'add_organization_tab',
                     insert_bottom: 'ul.nav-tabs',
                     text: '<%= render partial: "organization_tab" %>'

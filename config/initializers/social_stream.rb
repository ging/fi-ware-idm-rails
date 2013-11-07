SocialStream.setup do |config|
  # List the models that are social entities. These will have ties between them.
  # Remember you must add an "actor_id" foreign key column to your migration!
  #
  # config.subjects = [:user, :group, :site ]

  config.routed_subjects = [ :user, :organization, :application, :'site/current' ]

  # Include devise modules in User. See devise documentation for details.
  # Others available are:
  # :lockable, :timeoutable, :validatable
  config.devise_modules = :database_authenticatable, :registerable,
                          :recoverable, :rememberable, :trackable,
                          :omniauthable, :token_authenticatable,
                          :confirmable

  # Type of activities managed by actors
  # Remember you must add an "activity_object_id" foreign key column to your migration!
  # Be sure to add the other modules of Social Stream you might be using (e.g. :document, :event, :link ).
  #
  config.objects = []

  # Form for activity objects to be loaded
  # You can write your own activity objects
  #
  config.activity_forms = []

  config.custom_relations[:organization] = {}
  config.custom_relations[:application]  = {}

  config.system_relations[:organization] = [ :owner ]
  config.system_relations[:application]  = [ :manager, :purchaser ]

  config.available_permissions['group'] = [
    [ 'represent', nil ]
  ]
  config.available_permissions['site/client'] =
    config.available_permissions['application'] = [
      [ 'manage', nil ],
      [ 'manage', 'relation/custom' ],
      [ 'get', 'relation/custom' ],
      [ 'manage', 'contact' ]
    ]

  config.available_permissions['application'] = [
    [ 'manage', nil ],
    [ 'manage', 'relation/custom' ],
    [ 'manage', 'contact']
  ]

  # Expose resque interface to manage background tasks at /resque
  #
  config.resque_access = false

  # Quick search (header) and Extended search models and its order. Remember to create
  # the indexes with thinking-sphinx if you are using customized models.
  #
  config.quick_search_models = []
  config.extended_search_models = []

  # Cleditor controls. It is used in new message editor, for example
  # config.cleditor_controls = "bold italic underline strikethrough subscript superscript | size style | bullets | image link unlink"
end

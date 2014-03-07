FiWareIdm::Application.routes.draw do
  # FI-WARE compatible routes
  match '/authorize', to: 'authorizations#new'
  post  '/token', to: proc { |env| SocialStream::Oauth2Server::TokenEndpoint.new.call(env) }

  devise_for :users, :controllers => {:omniauth_callbacks => 'omniauth_callbacks', registrations: 'user_registrations'}

  namespace :permission do
    resources :customs
  end

  resources :purchases

  #SCIM 2.0 API
  namespace :v2 do
    match '/users/:id' => 'users#show', via: [:get]
  end

  match '/terms-of-service' => 'frontpage#terms_of_service', as: :terms_of_service
end

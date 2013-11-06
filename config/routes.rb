FiWareIdm::Application.routes.draw do
  # FI-WARE compatible routes
  match '/authorize', to: 'authorizations#new'
  post  '/token', to: proc { |env| SocialStream::Oauth2Server::TokenEndpoint.new.call(env) }

  devise_for :users, :controllers => {:omniauth_callbacks => 'omniauth_callbacks'}

  namespace :permission do
    resources :customs
  end

  resources :purchases

  match '/terms-of-service' => 'frontpage#terms_of_service', as: :terms_of_service
end

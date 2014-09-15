FiWareIdm::Application.routes.draw do
  # FIWARE compatible routes
  match '/authorize', to: 'authorizations#new'
  post  '/token', to: proc { |env| SocialStream::Oauth2Server::TokenEndpoint.new.call(env) }

  devise_for :users, :controllers => {:omniauth_callbacks => 'omniauth_callbacks', registrations: 'user_registrations'}

  namespace :permission do
    resources :customs
  end

  resources :purchases

  #Authentication Token API
  namespace :api do
    namespace :v1  do
      resources :tokens,:only => [:create, :destroy]
    end
  end

  #SCIM 2.0 API
  namespace :v2 do
    resources :users
    resources :organizations
    match '/ServiceProviderConfigs' => "base#getConfig"
    match '/testing' => "base#testing"
  end

  match '/terms-of-service' => 'frontpage#terms_of_service', as: :terms_of_service
end

Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  mount Decidim::Core::Engine => '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :consell_mallorca do
    namespace :admin do
      resource :authorization_config, only: [:edit, :update]
    end
  end
end

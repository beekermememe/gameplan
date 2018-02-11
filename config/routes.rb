# == Route Map
#
#                   Prefix Verb   URI Pattern                     Controller#Action
#     auth_oauth2_callback GET    /auth/oauth2/callback(.:format) auth0#callback
#             auth_failure GET    /auth/failure(.:format)         auth0#failure
#               home_index GET    /home/index(.:format)           home#index
#         new_user_session GET    /users/sign_in(.:format)        devise/sessions#new
#             user_session POST   /users/sign_in(.:format)        devise/sessions#create
#     destroy_user_session DELETE /users/sign_out(.:format)       devise/sessions#destroy
#        new_user_password GET    /users/password/new(.:format)   devise/passwords#new
#       edit_user_password GET    /users/password/edit(.:format)  devise/passwords#edit
#            user_password PATCH  /users/password(.:format)       devise/passwords#update
#                          PUT    /users/password(.:format)       devise/passwords#update
#                          POST   /users/password(.:format)       devise/passwords#create
# cancel_user_registration GET    /users/cancel(.:format)         devise/registrations#cancel
#    new_user_registration GET    /users/sign_up(.:format)        devise/registrations#new
#   edit_user_registration GET    /users/edit(.:format)           devise/registrations#edit
#        user_registration PATCH  /users(.:format)                devise/registrations#update
#                          PUT    /users(.:format)                devise/registrations#update
#                          DELETE /users(.:format)                devise/registrations#destroy
#                          POST   /users(.:format)                devise/registrations#create
#                     root GET    /                               home#index
# 

Rails.application.routes.draw do
  get "/auth/oauth2/callback" => "auth0#callback"
  get "/auth/failure" => "auth0#failure"

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "noticeboard#index"

  resources :opponents, only: [:show]

  resources :matches, only: [:index, :show, :update, :new, :create] do
    get :result
    get :opponents
    get :strengths
    get :weaknesses
    get :note_to_self
    get :search_opponents
    get :search_locations
    get :location
  end

  resources :coaches do

  end

  resources :analytics, only: [:index] do

  end

  resources :noticeboard, only: [:index] do

  end

  resources :lessons, only: [:index, :show, :update, :new, :create] do
    get :coaches_search
    get :coaches
    get :player_notes
  end

  resources :users, only: [:show, :update, :new, :delete_signup, :destroy] do

  end

  resources :courts, only: [:show]
end

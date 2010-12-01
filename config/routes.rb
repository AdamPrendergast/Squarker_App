SampleApp::Application.routes.draw do
  
  #get "users/new"

  #get "pages/home"
  #match '/', :to => 'pages#home' --- assigned to root

  match '/contact', :to => 'pages#contact'
  
  match '/about', :to => 'pages#about'
  
  match '/help', :to => 'pages#help'
  
  match '/signup', :to => 'users#new'
  
  root :to => 'pages#home'

  end

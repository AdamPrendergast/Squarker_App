SampleApp::Application.routes.draw do
  
  #get "pages/home"
  #match '/', :to => 'pages#home' --- assigned to root

  #get "pages/contact"
  match '/contact', :to => 'pages#contact'
  
  #get "pages/about"
  match '/about', :to => 'pages#about'
  
  match '/help', :to => 'pages#help'
  
  root :to => 'pages#home'

  end

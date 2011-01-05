require 'spec_helper'

  describe "LayoutLinks" do
    #render_views
  
    # Integration test to check routes
    
    it "should have a Home page at '/'" do
      get '/'
      response.should have_selector('title', :content => "Home")
    end
    
    it "should have a Contact page at '/contact'" do
      get '/contact'
      response.should have_selector('title', :content => "Contact")
    end

    it "should have an About page at '/about'" do
      get '/about'
      response.should have_selector('title', :content => "About")
    end

    it "should have a Help page at '/help'" do
      get '/help'
      response.should have_selector('title', :content => "Help")
    end
   
    it "should have a Signup page at '/signup'" do
      get '/signup'
      response.should have_selector('title', :content => "Sign up")
    end
    
    # Integration test to check links
    
    it "should have the right links on the layout" do
      visit root_path
      #save_and_open_page
      
      click_link "Home"
      response.should have_selector('title', :content => "Home")
      
      click_link "About"
      response.should have_selector('title', :content => "About")
      
      click_link "Contact"
      response.should have_selector('title', :content => "Contact")
      
      click_link "Help"
      response.should have_selector('title', :content => "Help")
      
      # The sign up test fails. does not find the link text in home.html.erb when it is rendered in <%= yield %>
      click_link "Signup"
      response.should have_selector('title', :content => "Sign up")
    end
    
    # Test layout links depending on whether a user is signed in or not
    
    describe "when not signed in" do
      
      it "should have a signin link" do
        visit root_path
        response.should have_selector("a", :href => signin_path,
        								   :content => "Sign in")
      end
    end
    
    describe "when signed in" do
    
      before(:each) do
        @user = Factory(:user)
        integration_sign_in(@user)
      end
      
      it "should have a signout link" do
        visit root_path
        response.should have_selector("a", :href => signout_path,
                                           :content => "Sign out")
      end
      
      it "should have a profile link" do
        visit root_path
        response.should have_selector("a", :href => user_path(@user),
                                           :content => "My profile")
      end
    
    end
    
  end

require 'spec_helper'

describe PagesController do
	render_views

### GET 'home'

  describe "GET 'home'" do
   
   it "should be successful" do
      get 'home'
      response.should be_success
    end
    
    it "should have the right title" do
  		get 'home'
  		response.should have_selector("title",
  								:content => "Ruby on Rails Tutorial Sample App | Home")
  	end
  	
  	describe "for signed in users" do
  	  
  	  before(:each) do
        @user = test_sign_in(Factory(:user))
        other_user = Factory(:user, :email => "otheruser@example.com")
        other_user.follow!(@user)
      end
      
      it "should have the singular display for one user micropost" do
        mp1 = Factory(:micropost, :user => @user)
        get 'home'
        response.should have_selector("span.microposts", :content => "micropost")
      end
      
      it "should have the plural display for many user microposts" do
        mp1 = Factory(:micropost, :user => @user)
        mp2 = Factory(:micropost, :user => @user)
        get 'home'
        response.should have_selector("span.microposts", :content => "micropost")
      end
      
      it "should paginate the micropost feed" do
        @microposts = []
        31.times do
          @microposts << Factory(:micropost, :user => @user)
        end
        get 'home'
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/?page=2",
                                           :content => "Next")
        response.should have_selector("a", :href => "/?page=2",
                                         :content => "2")
      end
      
      it "should have the right following/follower count" do
        get :home
        response.should have_selector("a", :href => following_user_path(@user),
                                           :content => "0 following")
        response.should have_selector("a", :href => followers_user_path(@user),
                                           :content => "1 follower")
      end
      
  	end
  	
  end

### GET 'contact'

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
    
    it "should have the right title" do
  		get 'contact'
  		response.should have_selector("title",
  								:content => "Ruby on Rails Tutorial Sample App | Contact")
  	end
  end
  
### GET 'about'  
  
  describe "GET 'about'" do
  	it "should be successful" do
  		get 'about'
  		response.should be_success
  	end
  	
  	it "should have the right title" do
  		get 'about'
  		response.should have_selector("title",
  								:content => "Ruby on Rails Tutorial Sample App | About")
  	end
  end
 

end

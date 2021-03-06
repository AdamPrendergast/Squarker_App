require 'spec_helper'

describe User do

	before(:each) do
	  @attr = { 
	    :name => "Example User", 
	    :email => "user@example.com", 
	    :password => "password", 
	    :password_confirmation => "password" 
	  }
	end
	
	
### ATTRIBUTE TESTS
	it "should create a new instance given valid attributes" do
	  User.create!(@attr)
	end
	
	it "should require a name" do
	  no_name_user = User.new(@attr.merge(:name => ""))
	  no_name_user.should_not be_valid
	end
	
	it "should require an email address" do
	  no_email_user = User.new(@attr.merge(:email => ""))
	  no_email_user.should_not be_valid
	end
	
	it "should reject a name attribute longer than 50 characters" do
	  long_name = "a" * 51
	  long_name_user = User.new(@attr.merge(:name => long_name))
	  long_name_user.should_not be_valid
	end
	
	it "should accept valid email addresses" do
	  addresses = %w[user@foo.com THE_USER@foo.com first.last@foo.com]
	  addresses.each do |address|
	    valid_email_user = User.new(@attr.merge(:email => address))
	    valid_email_user.should be_valid
	  end
	end
	
	it "should reject invalid email addresses" do
	  addresses = %w[user@foo,com the_user_at_foo.com example.user@foo.]
	  addresses.each do |address|
	    invalid_email_user = User.new(@attr.merge(:email => address))
	    invalid_email_user.should_not be_valid
	  end
	end
	
	it "should reject duplicate email addresses" do
	  User.create!(@attr)
	  duplicate_email_user = User.new(@attr)
	  duplicate_email_user.should_not be_valid
	end
	
	it "should reject duplicate email addresses up to case" do
	  upcased_email = @attr[:email].upcase
	  User.create!(@attr.merge(:email => upcased_email))
	  duplicate_email_user = User.new(@attr)
	  duplicate_email_user.should_not be_valid
	end
	
	
### PASSWORD VALIDATION TESTS
	describe "password validations" do
	
	  it "should require a password" do
	    no_password_user = User.new(@attr.merge(:password => "", :password_confirmation => ""))
	    no_password_user.should_not be_valid
	  end
	  
	  # Note the shorthand way of writing the test.
	  it "should require a matching password confirmation" do
	    User.new(@attr.merge(:password_confirmation => "invalid")).
	    should_not be_valid
	  end
	  
	  # hash variable created to make code easier to read
	  it"should reject short passwords" do
	    short_password = 'a' * 5
	    hash = @attr.merge(:password => short_password, :password_confirmation => short_password)
	    User.new(hash).should_not be_valid
	  end
	  
	  it "should reject long passwords" do
	    long_password = 'a' * 41
	    hash = @attr.merge(:password => long_password, :password_confirmation => long_password)
	    User.new(hash).should_not be_valid
	  end
	end
	
	
### PASSWORD TESTS
	describe "password encryption" do
	
	  before(:each) do
	    @user = User.create!(@attr)
	  end
	  
	  it "should have an encrypted password attribute" do
	    @user.should respond_to(:encrypted_password)
	  end
	  
	  it "should set the encrypted password" do
	    @user.encrypted_password.should_not be_blank
	  end
	  
	  
	  # has_password? method
	  describe "has_password? method" do
	    
	    it "should be true if the passwords match" do
	      @user.has_password?(@attr[:password]).should be_true
	    end
	    
	    it "should be false if the passwords do not match" do
	      @user.has_password?("invalid").should be_false
	    end
	  end
	  
	  
	  # authenticate method
	  describe "authenticate method" do
	    
	    it "should return nil on email/password mismatch" do
	      wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
	      wrong_password_user.should be_nil
	    end
	    
	    it "should be nil for an email address with no user" do
	      no_email_user = User.authenticate("not_stored@example.com", @attr[:password])
	      no_email_user.should be_nil
	    end
	    
	    it "should return the user on email/password match" do
	      matching_user = User.authenticate(@attr[:email], @attr[:password])
	      matching_user.should == @user
	    end
	    
	  end
	end
	
### ADMIN TESTS
	
	describe "admin attribute" do
	
	  before(:each) do
	    @user = User.create!(@attr)
	  end
	  
	  it "should respond to admin" do
	    @user.should respond_to(:admin)
	  end
	  
	  it "should not be an admin by default" do
	    @user.should_not be_admin
	  end
	  
	  it "should be convertible to an admin" do
	    @user.toggle(:admin)
	    @user.should be_admin
	  end
	
	end
	
### MICROPOST ASSOCIATIONS

  describe "micropost associations" do
  
    before(:each) do
      @user = User.create(@attr)
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end
    
    it "should have a microposts attribute" do
      @user.should respond_to(:microposts)
    end
    
    it "should have the microposts in the right order" do
      @user.microposts.should == [@mp2, @mp1]
    end
    
    it "should destroy micropost associations" do
      @user.destroy
      [@mp1, @mp2].each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end
    
    describe "status feed" do
  
      it "should have a feed" do
        @user.should respond_to(:feed)
      end
    
      it "should include the users microposts" do
        @user.feed.should include(@mp1)
        @user.feed.should include(@mp2)
      end
    
      it "should not include a different users microposts" do
        mp3 = Factory(:micropost,
                      :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.should_not include(mp3)
      end
      
      it "should include the microposts of followed users" do
        followed = Factory(:user, :email => Factory.next(:email))
        mp3 = Factory(:micropost, :user => followed)
        @user.follow!(followed)
        @user.feed.should include(mp3)
      end
      
    end
  end
  
### RELATIONSHIPS

  describe "relationships" do
    
    before(:each) do
      @user = User.create!(@attr)
      @followed = Factory(:user)
    end
    
    it "should have a relationships method" do
      @user.should respond_to(:relationships)
    end
    
    it "should have a following method" do
      @user.should respond_to(:following)
    end
    
    it "should have a following? method" do
      @user.should respond_to(:following?)
    end
    
    it "should have a follow! method" do
      @user.should respond_to(:follow!)
    end
    
    it "should follow another user" do
      @user.follow!(@followed)
      @user.should be_following(@followed)
    end
    
    it "should include the followed user in the following array" do
      @user.follow!(@followed)
      @user.following.should include(@followed)
    end
    
    it "should have an unfollow! method" do
      @user.should respond_to(:unfollow!)
    end

    it "should be able to unfollow a user" do
      @user.follow!(@followed)
      @user.unfollow!(@followed)
      @user.should_not be_following(@followed)
    end
    
    it "should have a reverse_relationships method" do
      @user.should respond_to(:reverse_relationships)
    end
    
    it "should have a followers method" do
      @user.should respond_to(:followers)
    end
    
    it "should include the follower in the followers array" do
      @user.follow!(@followed)
      @followed.followers.should include(@user)
    end
    
    it "should destroy relationship if user is deleted" do
      @user.follow!(@followed)
      @user.destroy
      @followed.followers.should_not include(@user)
    end
    
    it "should destroy relationship if the followed is deleted" do
      @user.follow!(@followed)
      @followed.destroy
      @user.following.should_not include(@followed)
    end
    
  end
  
end

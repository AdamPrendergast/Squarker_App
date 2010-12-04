require 'spec_helper'

describe User do

	before(:each) do
	  @attr = { :name => "Example User", :email => "user@example.com" }
	end
	
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

end
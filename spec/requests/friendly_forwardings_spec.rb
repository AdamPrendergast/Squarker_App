require 'spec_helper'

describe "FriendlyForwardings" do

  it "should forward to the requested page after signin" do
    user = Factory(:user)
    visit edit_user_path(user)
    # The test automatically follows the redirect to the signin page.
    fill_in "Email", :with => user.email               # can also user :Email instead of "Email"
    fill_in "Password", :with => user.password
    click_button
    # The test follows the redirect again, this time to users/edit.
    response.should render_template('users/edit')
  end
  
end

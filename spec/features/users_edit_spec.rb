require 'rails_helper'

RSpec.feature "UsersEdit", type: :feature do
  let(:user) { create :michael }
  
  specify "unsuccessful edit" do
    log_in_as(user)
    visit edit_user_path(user)
    expect(page).to have_selector 'h1', text: 'Update your profile'
    fill_in 'Name', with: ""
    fill_in 'Email', with: "user@invalid"
    fill_in 'Password', with: "foo"
    fill_in 'Confirmation', with: "bar"
    click_button 'Save changes'
    expect(page).to have_selector 'h1', text: 'Update your profile'
  end

  specify "successful edit with friendly forwarding" do
    visit edit_user_path(user)
    log_in_as(user)
    expect(current_path).to eq edit_user_path(user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    fill_in 'Name', with: name
    fill_in 'Email', with: email
    fill_in 'Password', with: ""
    fill_in 'Confirmation', with: ""
    click_button 'Save changes'
    expect(page).to have_selector '.alert'
    expect(current_path).to eq user_path(user)
    user.reload
    expect(user.name).to eq name
    expect(user.email).to eq email
  end
end

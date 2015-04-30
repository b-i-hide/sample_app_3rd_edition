require 'rails_helper'

RSpec.feature "Following", type: :feature do
  let(:user) { create :michael }
  let(:other) { create :archer }

  before do
    log_in_as(user)

    create :one
    create :two
    create :three
    create :four
  end

  specify "following page" do
    visit following_user_path(user)
    expect(user.following).to be_present
    expect(page).to have_content user.following.count
    user.following.each do |user|
      expect(page).to have_link nil, user_path(user)
    end
  end

  specify "followers page" do
    visit followers_user_path(user)
    expect(user.followers).to be_present
    expect(page).to have_content user.followers.count
    user.followers.each do |user|
      expect(page).to have_link nil, user_path(user)
    end
  end

  specify "should follow a user the standard way" do
    visit user_path(other)
    expect { click_button 'Follow' }.to change { user.following.count }.by(1)
  end

  # NOTE "should follow a user with Ajax" is tested in relationships_controller_spec

  specify "should unfollow a user the standard way" do
    user.follow(other)
    visit user_path(other)
    expect { click_button 'Unfollow' }.to change { user.following.count }.by(-1)
  end

  # NOTE "should unfollow a user with Ajax" is tested in relationships_controller_spec
end

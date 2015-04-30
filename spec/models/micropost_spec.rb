require 'rails_helper'

RSpec.describe Micropost, type: :model do
  before do
    @user = FactoryGirl.create :michael_with_microposts
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  specify "should be valid" do
    expect(@micropost.valid?).to be_truthy
  end
  
  specify "user id should be present" do
    @micropost.user_id = nil
    expect(@micropost.valid?).to be_falsey
  end

  specify "content should be present" do
    @micropost.content = "   "
    expect(@micropost.valid?).to be_falsey
  end

  specify "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    expect(@micropost.valid?).to be_falsey
  end

  specify "order should be most recent first" do
    content = FactoryGirl.attributes_for(:most_recent)[:content]
    most_recent = Micropost.find_by! content: content
    expect(Micropost.first).to eq most_recent
  end
end

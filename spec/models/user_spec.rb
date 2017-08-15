require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.create(:user) }

  it "is valid" do
    expect(user).to be_valid
  end

  it "expects name to be present" do
    user.name = "     "
    expect(user).to_not be_valid
  end

  it "expects email to be present" do
    user.email = "     "
    expect(user).to_not be_valid
  end

  it "expects name to not be too long" do
    user.name = 'a' * 51
    expect(user).to_not be_valid
  end

  it "expects email to not be too long" do
    user.email = "a" * 244 + "@example.com"
    expect(user).to_not be_valid
  end

  it "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user).to be_valid, "#{valid_address.inspect} should be valid"
    end
  end

  it "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user).to_not be_valid, "#{invalid_address.inspect} should be invalid"
    end
  end

  it "make sure u cant have duplicate emails" do
    user_with_dup_email = build(:user, email: user.email)
    expect(user_with_dup_email).to_not be_valid
  end

  it "is case insensitive" do
    user.email.upcase
    user.save
    expect(user).to be_valid
  end

  it "downcases emails" do
    user.email = "BOB@MAIL.COM"
    user.validate
    expect(user.email).to eq "bob@mail.com"
  end

  it "makes sure password should be present (nonblank)" do
    user.password = user.password_confirmation = " " * 6
    expect(user).to_not be_valid
  end

  it "password should have a minimum length" do
    user.password = user.password_confirmation = "a" * 5
    expect(user).to_not be_valid
  end

  it "expects authenticated? should return false for a user with nil digest" do
    expect(user.authenticated?(:remember, '')).to eq false
  end
end




require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.account_activation(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Account Activation")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(user.name)
      expect(mail.body.encoded).to match(user.activation_token)
      expect(mail.body.encoded).to match(CGI.escape(user.email))
    end
  end

  describe "password reset" do
    let(:user2) { FactoryGirl.create(:user, :reset_token) }
    let(:mail) { UserMailer.password_reset(user2) }

    it "renders the headers" do
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq([user2.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(user2.reset_token)
      expect(mail.body.encoded).to match(CGI.escape(user2.email))
    end
  end
end

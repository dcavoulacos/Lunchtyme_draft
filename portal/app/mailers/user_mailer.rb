class UserMailer < ActionMailer::Base

  default from: "match@lunchtyme.com"

  def welcome_email(user)
    @user = user
    @url  = 'http://localhost:3000'
    mail(to: @user.email, subject: 'Welcome to LunchtYme!')
  end

  def match_email(user)
    @user = user
    @url = 'http://localhost:3000/entries/new?message_type=match'
    mail(to: @user.email, subject: 'You have been Matched!')
  end
end
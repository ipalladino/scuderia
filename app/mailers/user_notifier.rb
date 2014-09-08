class UserNotifier < ActionMailer::Base
  default from: "Ignacio Palladino @scuderia"

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email(user)
    @user = user
    mail( :to => @user.email,
    :subject => 'Thanks for signing up to SCUDERIA.COM!' )
  end

  def send_saved_search_notification(user, ferrari, saved_search, url)
    @url = url
    @user = user
    @ferrari = ferrari
    @saved_search = saved_search
    mail( :to => @user.email,
    :subject => 'We found a Ferrari you might be interested on.' )
  end

end

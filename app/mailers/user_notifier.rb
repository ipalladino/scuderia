class UserNotifier < ActionMailer::Base
  default from: "Ignacio <no-reply@scuderia.com>"

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email(user)
    @user = user
    mail( :to => @user.email,
    :subject => 'Thanks for signing up to SCUDERIA.COM!' )
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

  def send_saved_search_notification(user, ferrari, saved_search, url)
    @url = url
    @user = user
    @ferrari = ferrari
    @saved_search = saved_search
    mail( :to => @user.email,
    :subject => 'We found a Ferrari you might be interested on.' )
  end

  def send_expired_ferrari_notification(ferrari)
    @ferrari = ferrari
    @user = ferrari.user
    mail(:to => @user.email,
    :subject => 'Your Ferrari publication on Scuderia.com has expired' )
  end

  def send_ferrari_published_notification(ferrari)
    @ferrari = ferrari
    @user = ferrari.user
    mail(:to => @user.email,
    :subject => 'Your Ferrari has been published' )
  end

end

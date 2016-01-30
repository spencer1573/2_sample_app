class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    # so mail is a method that takes in to and subject symbols
    # or key value pairs?
    mail to: user.email, subject: "Account activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
		#it is important to note that mail can be written 
		# perhaps more clearly like this
#   mail(to: user.email, subject: "Password reset")
    mail to: user.email, subject: "Password reset"
    
  end
  
end

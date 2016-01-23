# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at 
  # http://localhost:3000/rails/mailers/user_mailer/account_activation
  # https://ubuntu-test-spencer1573.c9.io/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at 
  # http://localhost:3000/rails/mailers/user_mailer/password_reset
  # https://ubuntu-test-spencer1573.c9.io/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    # this reset_token is found on line 5 of the user model
    # this new_token comes from line 38 of the user model i believe
    # it looks like it just selects a random base 64 jumble of garbage numbers i thinkg 
    user.reset_token = User.new_token
    # this appears to be located in the app/mailers/user_mailer.rb
    UserMailer.password_reset(user)
  end

end

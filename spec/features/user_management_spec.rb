require_relative '../factories/user'

feature 'User sign up' do

  scenario 'I can sign up as a new user' do
    user = build :user
    sign_up(user)
    expect(page).to have_content("Welcome, #{user.email}")
  end

  scenario 'with a password that does not match' do
     user = create :user
     user.password_confirmation = 'wrong'
     sign_up(user)
     expect(page).to have_content 'Password does not match the confirmation'
   end

   scenario 'requires an email to sign up' do
     user = create :user
     user.email = nil
     sign_up(user)
     expect(page).to have_content 'Email must not be blank'
   end

  scenario 'I cannot sign up with an existing email' do
    user = create :user
    visit '/users/new'
    sign_up(user)
    expect(page).to have_content('Email is already taken')
  end

end

feature 'User sign in' do

  scenario 'with correct credentials' do
    user = create :user
    sign_in(user)
    expect(page).to have_content "Welcome, #{user.email}"
  end

end

feature 'User signs out' do

  scenario 'while being signed in' do
    user = create :user
    sign_in(user)
    click_button 'Sign Out'
    expect(page).to have_content('Goodbye!')
    expect(page).not_to have_content("Welcome, #{user.email}")
  end

end

feature 'Password reset' do

 scenario 'requesting a password reset' do
   user = create :user
   sign_in(user)
   visit '/password_reset'
   fill_in 'email', with: user.email
   click_button 'Reset password'
   user = User.first(email: user.email)
   expect(user.password_token).not_to be_nil
   expect(page).to have_content 'Check your emails'
 end

 scenario 'resetting password' do
    user = create :user
    sign_in(user)
    user.password_token = 'token'
    user.save
    visit "/password_reset/#{user.password_token}"
    expect(page.status_code).to eq 200
    expect(page).to have_content 'Enter a new password'
  end

  scenario 'updating user password' do
    user = create :user
    sign_in(user)
    visit '/password_reset'
    fill_in 'email', with: user.email
    click_button 'Reset password'
    visit "/password_reset/#{user.password_token}"
    fill_in 'password', with: 'apples'
    fill_in 'password_confirmation', with: 'apples'
    click_button 'Change password'
    expect(page).to have_content 'Your password has been updated'
  end

  scenario 'voiding password token' do
    user = create :user
    sign_in(user)
    user.password_token = 'xyz'
    visit "/password_reset/xyz"
    fill_in 'password', with: 'apples'
    fill_in 'password_confirmation', with: 'apples'
    click_button 'Change password'
    user = User.first(email: user.email)
    expect(user.password_token).to be_nil
  end

  scenario 'lets user sign in with updated password' do
    user = create :user
    sign_in(user)
    visit "/password_reset/xyz"
    fill_in 'password', with: 'apples'
    fill_in 'password_confirmation', with: 'apples'
    click_button 'Change password'
    click_button 'Sign Out'
    user.password = 'apples'
    sign_in(user)
    expect(page).to have_content "Welcome, #{user.email}"
  end

end

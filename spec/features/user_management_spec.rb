require_relative '../factories/user'

def sign_up(user)
  visit '/users/new'
  fill_in :email, with: user.email
  fill_in :password, with: user.password
  fill_in :password_confirmation, with: user.password_confirmation
  click_button 'Sign Up'
end

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

  def sign_in(user)
    visit '/sessions/new'
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button 'Sign In'
  end

end

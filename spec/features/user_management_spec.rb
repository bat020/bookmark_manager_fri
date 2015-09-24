require_relative '../factories/user'

feature 'User sign up' do

  scenario 'I can sign up as a new user' do
    user = create :user
    visit '/users/new'
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    fill_in :password_confirmation, with: user.password_confirmation
    click_button 'Sign Up'
    expect(page).to have_content("Welcome, #{user.email}")
  end

  scenario 'with a password that does not match' do
     user = create :user
     visit '/users/new'
     fill_in :email, with: user.email
     fill_in :password, with: user.password
     fill_in :password_confirmation, with: 'wrong'
     click_button 'Sign Up'
     expect(page).to have_content 'Password and confirmation password do not match'
   end

   scenario 'requires an email to sign up' do
     user = create :user
     visit '/users/new'
     fill_in :email, with: nil
     click_button 'Sign Up'
     expect(page).to have_content 'Please enter an email address'
   end

  scenario 'I cannot sign up with an existing email' do
    sign_up_as(user)
    expect { sign_up_as(user) }.to change(User, :count).by(0)
    expect(page).to have_content('Email is already taken')
  end



end

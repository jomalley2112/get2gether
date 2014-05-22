module Macros
	def sign_in_capybara(person)
		visit new_person_session_path
		fill_in("Email", :with => person.email)
		fill_in("Password", :with => person.password)
		click_button "Sign in"
	end
end
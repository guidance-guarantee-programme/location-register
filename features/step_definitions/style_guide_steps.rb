When(/^I visit the style guide$/) do
  visit '/style-guide'
end

Then(/^the page is rendered correctly$/) do
  # check that header from layout has rendered
  expect(page).to have_css('header.navbar')
end

When(/^I retrieve locations data$/) do
  @response = get locations_path, format: 'json'
end

Then(/^I receive a JSON response$/) do
  expect(@response.content_type).to eq('application/json; charset=utf-8')
end

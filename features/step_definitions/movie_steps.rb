# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(:title => movie[:title], :rating => movie[:rating], :release_date => movie[:release_date])
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  match = /#{e1}.*#{e2}/m =~ page.body
  assert false if match.nil?
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  if uncheck.nil?
    rating_list.split(", ").each do |rat|
      step %{I check "ratings_#{rat}"}
    end
  else
     rating_list.split(", ").each do |rat|
     step %{I uncheck "ratings_#{rat}"}
    end
  end
end

Then /I should see all of the movies/ do
  rows = Movie.count
  page.should have_css("table#movies tr", :count=>rows+1)
end

Then /I should see none of the movies/ do
  page.should have_css("table#movies tr", :count=>1)
end
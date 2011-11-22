require File.expand_path(File.join(File.dirname(__FILE__), *%w[polyfromage]))
include Capybara::DSL

def page_title
  page.find('title').text
end

# Available drivers according to the selenium-webdriver gem:
# :firefox, :ff, :remote, :ie, :internet_explorer, :chrome, :android, :iphone, :opera
# (Note: Safari not available)
PolyFromage.in_browsers(:firefox, :chrome) do |browser|
  puts "Now running in #{browser.inspect}"

  # Basic setup
  Capybara.app_host = 'http://www.google.com'
  Capybara.run_server = false

  # Do the thing
  visit '/'
  basic_title = page_title
  fill_in 'q', :with => 'cheese'
  click_button 'Search'

  # If we don't wait a little while, we'll just get "Google" as the page title.
  # However, using #sleep is dumb.  Just wait long enough for it to change.
  page.wait_until do
    page_title != basic_title
  end

  # Just show the output, but could assert just as easily
  puts 'Page title is: "%s"' % page.find('title').text
end

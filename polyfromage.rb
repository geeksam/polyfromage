require 'rubygems'
require 'bundler'
Bundler.setup
require 'capybara/dsl'


KnownDrivers = []

module PolyFromage
  module_function

  def in_browsers(*browsers)
   browsers.each do | browser |
      Capybara.current_driver = driver_for(browser)
      yield browser
    end
  end

protected
module_function
  def driver_for(browser)
   :"selenium_#{browser}".tap do | name |
      new_driver(name, browser) unless KnownDrivers.include?(name)
    end
  end

  def new_driver(name, browser)
   Capybara.register_driver name do | app |
      Capybara::Selenium::Driver.new(app, :browser => browser.to_sym)
    end
    KnownDrivers << name
  end
end

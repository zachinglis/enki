require 'spec'

case PLATFORM
when /darwin/
  require 'safariwatir'
  Watir::Browser = Watir::Safari
when /win32|mingw/
  require 'watir'
  Watir::Browser = Watir::IE
when /java/
  require 'celerity'
  Watir::Browser = Celerity::Browser
else
  raise "This platform is not supported (#{PLATFORM})"
end

class GoogleSearch
  def initialize(b)
    @b = b
  end
  
  def goto
    @b.goto 'http://www.google.com/'
  end
  
  def search(text)
    @b.text_field(:name, 'q').set(text)
    @b.button(:name, 'btnG').click
  end
end

Before do
  @b = Watir::Browser.new
end

After do
  @b.close
end

Given 'I am on the Google search page' do
  @page = GoogleSearch.new(@b)
  @page.goto
end

When /I search for "(.*)"/ do |query|
  @page.search(query)
end

Then /I should see a link to "(.*)":(.*)/ do |text, url|
  @b.link(:url, url).text.should == text
end

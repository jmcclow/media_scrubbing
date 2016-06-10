#!/usr/local/bin/ruby
require "net/https"
require "uri"
require 'mechanize'

http = Net::HTTP.new("nixle.com", 443)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE


agent = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
}

keep_movin = true
on_page = 1
while keep_movin do
  agent.get("https://nixle.com/simi-valley-police-department/?page=#{on_page}")
  loop do
    # do what you want to do with each page
    pagina = agent.page
    next_link = agent.page.links_with(:text => 'More »').each do |link|
      link.click
      puts agent.page.at('div[id="alert-body"]').text
    end
    advisory = agent.page.at('p.headline_agency')
    if advisory
      puts advisory.text
    else
      break
    end
  end
  on_page = on_page + 1
end

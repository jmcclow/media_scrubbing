#!/usr/local/bin/ruby
require 'rubygems'
require 'bundler/setup'
require 'net/https'
require 'uri'
require 'mechanize'

http = Net::HTTP.new("nixle.com", 443)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE


agent = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
}

keep_movin = true
on_page = 1
regex_match = %r|(\d+)(?:\sblock\sof)(\s+\S+){3}|i
regex_clean = %r|(block of)|i
while keep_movin do
  agent.get("https://nixle.com/simi-valley-police-department/?page=#{on_page}")
  loop do
    # do what you want to do with each page
    pagina = agent.page
    next_link = agent.page.links_with(:text => 'More »').each do |link|
      link.click
      page = agent.page.at('div[id="alert-body"]').text.match(regex_match)
      if page
        to_print = page.to_s.gsub(regex_clean, '')
        puts to_print
      end
    end
    advisory = agent.page.at('p.headline_agency')
    if advisory
      page = advisory.text
      if page
        to_print = page.to_s.gsub(regex_clean, '')
        puts to_print
      end
    else
      break
    end
  end
  on_page = on_page + 1
end

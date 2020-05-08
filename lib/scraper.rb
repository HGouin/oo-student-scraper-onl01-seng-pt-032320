require 'open-uri'
require 'pry'


class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    student_cards = doc.css(".student-card")
    student_cards.map do |student_card|
      {
        :name => student_card.css("h4.student-name").text,
        :location => student_card.css("p.student-location").text,
        :profile_url => student_card.css("a")[0]['href']
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    links = doc.css(".social-icon-container a")
    profile = {
      :profile_quote => doc.css("div.profile-quote").text,
      :bio => doc.css("p").text
    }
    links.each do |a|
      if a['href'].include?("twitter.com")
        profile[:twitter] = a['href']
      elsif a['href'].include?("linkedin.com")
        profile[:linkedin] = a['href']
      elsif a['href'].include?("github.com")
        profile[:github] = a['href']
      else
        profile[:blog] = a['href']
      end
    end
    {
      :twitter => (doc.css(".social-icon-container a").find{|a| a['href'].include?("twitter.com")} || {})['href'],
      :linkedin => (doc.css(".social-icon-container a").find{|a| a['href'].include?("linkedin.com")} || {})['href'],
      :github => (doc.css(".social-icon-container a").find{|a| a['href'].include?("github.com")} || {})['href'],
      :blog => (doc.css(".social-icon-container a").find{|a| a['href'].include?("flatironschool.com")} || {})['href'],

      :profile_quote => doc.css("div.profile-quote").text,
      :bio => doc.css("p").text

    }
  end

end

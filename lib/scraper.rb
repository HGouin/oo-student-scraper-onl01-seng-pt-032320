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
    {
      news_links = page.css("a").select{|link| link['data-category'] == "news"}
      news_links.each{|link| puts link['href'] }
      :twitter => doc.css("a").select{|link| link['social-icon-container'] == "twitter",
      :linkedin => doc.css(".social_icon_container a").select{|a| a['href'].include?("linkedin.com")}['href'],
      :github => doc.css(".social_icon_container a").select{|a| a['href'].include?("github.com")}['href'],
      :blog => doc.css(".social_icon_container a").select{|a| a['href'].include?("flatironschool.com")}['href'],
      :profile_quote => doc.css("div.profile_quote").text,
      :bio => doc.css("div.bio-content content-holder").text
    }
  end

end

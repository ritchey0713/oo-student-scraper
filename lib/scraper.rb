require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []
    index_page.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        profile_link = student.attr("href") 
        location = student.css(".student-location").text
        name = student.css(".student-name").text
        students << {name: name, location: location, profile_url: profile_link}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    profile_page = Nokogiri::HTML(open(profile_url))
    links = profile_page.css(".social-icon-container").children.css("a").map {|ele| ele.attr("href")}

    links.each do |link|
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      elsif link.include?("github")
        student[:github] = link
      else
        student[:blog] = link
    end
  end

    student[:bio] = profile_page.css(".bio-content.content-holder div.description-holder p").text if profile_page.css(".bio-content.content-holder div.description-holder p")
    student[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")

    student
  end

end

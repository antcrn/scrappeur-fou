require 'nokogiri'
require 'open-uri'
require 'pp'

doc = Nokogiri::HTML(URI.open('http://annuaire-des-mairies.com/val-d-oise'))
commune=[]
doc.css('td > p > a.lientxt').each do |ville|
  commune << ville.text
end



lien=[]
doc.xpath('//a[contains(@href,"95")]/@href').each do |ville_lien|
  url_mairie= ville_lien.to_s
  lien << "http://annuaire-des-mairies.com"+url_mairie[1,100]
  end



courriel=[]
 lien.each do |url_mairie|
 doc2 = Nokogiri::HTML(URI.open(url_mairie))
 doc2.css("body > div > main > section:nth-child(2) > div > table > tbody > tr:nth-child(4) > td:nth-child(2)").each do |mail_mairie|
    if mail_mairie.text == ""
        str = "pas de mail"
       courriel << str
    else    
    courriel << mail_mairie.text
    end
end
end

if commune.length==courriel.length
    output=commune.zip(courriel).map{|k,v| {k => v}}
    pp output
end

require 'nokogiri'
require 'open-uri'
require 'pp'

# Fetch and parse HTML document
doc = Nokogiri::HTML(URI.open('https://coinmarketcap.com/'))
nombre_page=[]
doc.xpath('//*[@id="__next"]/div[1]/div[1]/div[2]/div/div[1]/div[4]/div[1]/div/ul/li').each do |pagination|
  nombre_page << pagination.content.to_i
end

nombre_de_page_max=nombre_page.uniq.last
arr_crypto=[]
arr_price=[]


########
# crypto
########
nombre_de_page_max.times do |i|
  doc = Nokogiri::HTML(URI.open("https://coinmarketcap.com/?page=#{i+1}"))
  doc.xpath('//*[@id="__next"]/div[1]/div[1]/div[2]/div/div[1]/div[2]/table/tbody/tr/td[3]/div/a/div/div/div/p').each do |cryptomoula|
    arr_crypto << cryptomoula.text
  end
  doc.xpath('//*[@id="__next"]/div[1]/div[1]/div[2]/div/div[1]/div[2]/table/tbody/tr/td[3]/a/span[3]').each do |cryptomoula|
    arr_crypto << cryptomoula.text
  end
end


########
# price
########

nombre_de_page_max.times do |i|
  doc = Nokogiri::HTML(URI.open("https://coinmarketcap.com/?page=#{i+1}"))
  doc.xpath('//*[@id="__next"]/div[1]/div[1]/div[2]/div/div[1]/div[2]/table/tbody/tr/td[4]/div/a').each do |price_crypto|
    arr_price << price_crypto.content.delete("$")
  end
  doc.xpath('//*[@id="__next"]/div[1]/div[1]/div[2]/div/div[1]/div[2]/table/tbody/tr/td[4]/span').each do |price_crypto|
    arr_price << price_crypto.content.delete("$")
  end
end

if arr_crypto.length==arr_crypto.length
 output=Hash[arr_crypto.zip(arr_price)]
 pp output
end

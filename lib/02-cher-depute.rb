#https://www2.assemblee-nationale.fr/deputes/liste/tableau

require 'nokogiri'
require 'open-uri'
require 'pp'
require 'pry'


###########
# url list
###########
def lien
    doc = Nokogiri::HTML(URI.open('https://www2.assemblee-nationale.fr/deputes/liste/alphabetique'))
    deputes=[]
    doc.xpath('//a[contains(@href,"fiche")]/@href').each do |lien|
        deputes.push("https://www2.assemblee-nationale.fr"+lien.content)
    end

    return deputes
end


###########
# mail list
###########
def mel
courriel=[]
lien.each do |liens_deputes|
    doc3 = Nokogiri::HTML(URI.open(liens_deputes))
    requete_mail=doc3.css("#haut-contenu-page > article > div.contenu-principal.en-direct-commission.clearfix > div > dl > dd > ul > li:nth-child(2) > a")
    requete_mail.each do |deputes_fiche|
        if deputes_fiche==nil
        courriel << "pas de mail"
        else
            courriel << deputes_fiche.text
        puts deputes_fiche.text
        end
    end
end
return courriel
end


################
# firstname list
################
def prenom
    g = Nokogiri::HTML(URI.open('https://www2.assemblee-nationale.fr/deputes/liste/alphabetique'))
    nom_complet=[]
    g.xpath('//*[@id="deputes-list"]/div/ul/li/a').each do |lien|
       nom_complet.push(lien.text.split(" "))
    end
    liste_prenom_nom=[]
    nom_complet.each do |element|
        liste_prenom_nom.push(element.drop(1))
    end
    liste_prenom=[]
    liste_prenom_nom.each do |part|
        liste_prenom.push(part[0])    
    end

    return liste_prenom
end


###############
# lastname list
###############
def nom
    g = Nokogiri::HTML(URI.open('https://www2.assemblee-nationale.fr/deputes/liste/alphabetique'))
    nom_complet=[]
    g.xpath('//*[@id="deputes-list"]/div/ul/li/a').each do |lien|
        nom_complet.push(lien.text.split(" "))
    end
    liste_prenom_nom=[]
    nom_complet.each do |element|
        liste_prenom_nom.push(element.drop(1))
    end
    liste_prenom=[]
    liste_prenom_nom.each do |part|
        liste_prenom.push(part[0])    
    end
    liste_nom=[]
    liste_prenom_nom.each do |part_nom|
        if part_nom.length==2
            liste_nom.push(part_nom[1])
        else
        liste_nom.push(part_nom[1..10].join(" "))    
        end
    end

    return liste_nom
end


###########
# MAIN
###########
def main
    nom.zip(prenom, mel).map { |nm, prn, ml| { first_name: prn, last_name: nm, email: ml } }
end


pp mel.length
class ScraperController < ApplicationController
  require 'openssl'
  require 'nokogiri'
  require 'open-uri'

  def scrape
    url = "https://us.banggood.com/Wholesale-Warehouse-1-wp-Usa-1227976.html?akmClientCountry=VN&rmmds=DSdownloadcenter"
    doc = Nokogiri::HTML(open(url))
    byebug
    @variant_image = doc.css('div.pro_attr_box > table')
  end

  def test_api

  end
end

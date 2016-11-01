#require 'bundler'
require 'bigcommerce'
require 'csv'
require 'date'

#Bundler.require

Bigcommerce.configure do |config|
  config.auth = 'legacy'
  config.url = ''
  config.username = ''
  config.api_key = ''
end

products = {}
headers = ['id', 'product_title', 'product_url', 'review_content', 'review_score', 'review_title', 'display_name', 'product_image_url', 'date']
number_of_pages = (Bigcommerce::Product.count[:count].to_f / 250).ceil

puts 'Loading product data...'

for page in 1..number_of_pages
  print page.to_s + ' '
  Bigcommerce::Product.all(page: page, limit: 250).each do |product|
    image = Bigcommerce::ProductImage.all(product[:id]).first
    if !image.nil?
      image = image[:zoom_url]
    else
      image = ''
    end
    products[product[:id]] = { :name => product[:name], :url => product[:custom_url], :image => image }
  end
end

puts 'Exporting reviews for product...'

CSV.open('yotpo-reviews.csv', 'a') do |csv|
  csv << headers
  products.each do |id, product|
    review_count = Bigcommerce::ProductReview.all(id).count
    if review_count > 0
      puts product[:name]
      Bigcommerce::ProductReview.all(id).each do |review|
        date = DateTime.parse(review[:date_created]).strftime('%Y-%m-%d')
        csv << [id, product[:name], product[:url], review[:review], review[:rating], review[:title], review[:author], product[:image], date]
      end
    end
  end
end

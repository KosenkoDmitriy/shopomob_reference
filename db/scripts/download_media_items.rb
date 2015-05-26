#bundle exec rails runner "eval(File.read '/Users/dmitrij/Dev/prj/rails/prj/shopomob_reference/db/scripts/download_media_items.rb')"
require "open-uri"

@host = "http://localhost:3000"
#@host = "http://ref.shopomob.ru"

@path_to_uploads = File.dirname(__FILE__)+"/uploads/"

Dir.mkdir(@path_to_uploads) if !Dir.exist?(@path_to_uploads)

def download_and_save file_name, file_url
    url = "#{@host}/#{file_url}"
    puts url
    begin
        open(url) {|f|
            File.open(@path_to_uploads+file_name,"wb") do |file|
                file.puts f.read
                puts @path_to_uploads+file_name
            end
        }
    rescue OpenURI::HTTPError => e
        puts "Can't access #{ url }"
        puts e.message
        puts
#        next
    end
end

# downloading banners
Banner.all.each do |item|
    if item.present? && item.image.present? && item.image.url.present?
      name = "b#{item.shop_id}.png"
      download_and_save name, item.image.url
    end
end


Image.all.each do |item|
  if item.present? && item.image_file_name.present? && item.image.present? && item.image.url.present?
    download_and_save item.image_file_name, item.image.url(:medium)
  end
end


#wget -i file.name.with.media.urls.

require 'csv'


def write_shops cat
  file_name = "#{cat.id} #{cat.name}".gsub(/\//, "")


  file_path = Rails.root.join("db", "csv", "export", "#{file_name}.csv")
  puts "update shops to >> #{file_path}"
  if (cat.present? && cat.shops.present?)
    @shops = cat.shops
    puts "shops count #{cat.shops.count}"
  else
    puts "no shops in cat #{cat.name}"
  end
  headers = ["имя", "телефон (отдел)", "часы работы", "адрес", "@", "сайт"]
  CSV.open( file_path, 'w+' ) do |writer|
    writer << headers
    @shops.each do |s|
      phones = ""
      emails = ""
      urls = ""
      if (s.contact_items.present?)
        s.contact_items.each do |ci|
          if ci.present?
            phones += "#{ci.value} (#{ci.department})\n" if ci.contact_type_id == 3 # only phones
            emails += "#{ci.value}\n" if ci.contact_type_id == 2 # only emails
            urls += "#{ci.value}\n" if ci.contact_type_id == 1 # only urls
          end
        end
      end
      #puts "#{s.name}|#{phones}"
      writer << [ s.name, phones, s.time_work, s.address, emails, urls ]
    end
  end
end

#Dir::mkdir(file_path)
#file = "#{Rails.root}/public/data.csv"
keywords = [ "Ресторан", "Магазин" ]
keywords.each do |k|
  cats = CategoryItem.where("name like ?", "%#{k}%")
  if (cats.present?)
    cats.each do |category|
      if (category.present?)
        if (category.parent_id > 0)
          puts "   category : #{category.name}"
          write_shops category
        else
          puts " parent category : #{category.name}"
          subcats = CategoryItem.where(parent_id: category.id).order(:name)
          if (subcats.present?)
            subcats.each do |sub_cat|
              puts "   category : #{sub_cat.name} "
              write_shops sub_cat
            end
          end
        end
      end

    end
  end
end

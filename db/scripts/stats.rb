# load './db/scripts/stats.rb'

shops_without_contacts = []
phones_count=0
emails_count=0
urls_count=0
addresses_count=0
additional_addresses_count=0
phones_count_all=0
Shop.all.each do |shop|
  emails_count += 1 if shop.try(:email).present? && shop.try(:email).split(",").count > 0
  urls_count += 1 if shop.try(:www).present? &&  shop.try(:www).split(",").count > 0
  addresses_count += 1 if shop.try(:address).present?
  if shop.contact_items.blank?
    shops_without_contacts << shop
  else
    shop.contact_items.each do |contact|
      phones_count_all += contact.try(:value).split(",").count if contact.try(:contact_type).try(:name) == "phone" && contact.try(:value).split(",").count > 0
      phones_count += 1 if contact.try(:contact_type).try(:name) == "phone" && contact.try(:value).present?
      emails_count += 1 if contact.try(:contact_type).try(:name) == "email"
      urls_count += 1 if contact.try(:contact_type).try(:name) == "url"
      #addresses_count += 1 if contact.try(:contact_type).try(:name) == "address"
      additional_addresses_count += 1 if contact.try(:contact_type).try(:name) == "address"
    end
  end
end
puts "shops_without_contacts.count: #{shops_without_contacts.count}"
puts "shops_with_phones.count: #{phones_count}"
puts "shops_with_phones_all.count: #{phones_count_all}"
puts "shops_with_emails.count: #{emails_count}"
puts "shops_with_urls.count: #{urls_count}"
puts "shops_with_addresses.count: #{addresses_count}"
puts "additional_addresses_count.count: #{additional_addresses_count}"
puts "uniq_addresses_total.count: #{additional_addresses_count+addresses_count}"

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

c = Category.create(name:'Category 1')
sc = Category.create(name:'1.1 Category', parent:c)

s = c.shops.create(name:'Shop 1')

ct_mail = ContactType.create(name:'email', value:'Email Address')
ct_url = ContactType.create(name:'url', value:'Website or other link')
ct_phone = ContactType.create(name:'phone', value:'Phone Number')

ci = ContactItem.create(name:'Phone Number (mobile)', value:'7324134214', shop:s, contact_type:ct_phone)
ci = ContactItem.create(name:'Email (Sales)', value:'sales@ex.com', shop:s, contact_type:ct_mail)
ci = ContactItem.create(name:'Website (Official)', value:'www.ex.com', shop:s, contact_type:ct_url)
ci = ContactItem.create(name:'Facebook', value:'www.facebook.com/ex', shop:s, contact_type:ct_url)
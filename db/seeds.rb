# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

load Rails.root.join('db', 'scripts', 'main_init.rb') # main init

#load Rails.root.join('db', 'scripts', 'add_orgs_from_json.rb') #load orgs from csv file
#load Rails.root.join('db', 'scripts', 'add_orgs_from_csv.rb') #load orgs from csv file

#load Rails.root.join('db', 'scripts', 'add_orgs_from_csv_v2.rb') #load orgs from csv file
#load Rails.root.join('db', 'scripts', 'add_orgs_from_json_v2.rb') #load orgs from csv file

#load Rails.root.join('db', 'scripts', 'add_orgs_from_csv_v4.rb') #load orgs from csv file
#load Rails.root.join('db', 'scripts', 'add_orgs_from_json_v4.rb') #load orgs from csv file

load Rails.root.join('db', 'scripts', 'add_orgs_from_csv_v5.rb') #load orgs from csv file
load Rails.root.join('db', 'scripts', 'add_orgs_from_json_v4.rb') #load orgs from csv file

#remove duplicates
#Shop.dedupe

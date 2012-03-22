# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Home.delete_all
Home.create(:street => '5500 Owensmouth Ave',
            :unit => '227',
            :city => 'Woodland Hills',
            :state => 'CA',
            :zip => '91367')

Home.create(:street => '4500 Park Granada',
            :unit => '',
            :city => 'Calabasas',
            :state => 'CA',
            :zip => '91302')

Home.create(:street => '21450 Vanowen St',
            :unit => '101',
            :city => 'Canoga Park',
            :state => 'CA',
            :zip => '91303')


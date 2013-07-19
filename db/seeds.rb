# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Book.delete_all
200.times do
  Book.create(
    title: Forgery(:name).full_name,
    subtitle: Forgery(:name).full_name,
    author: Forgery(:name).full_name,
    isbn: Forgery(:basic).number(:at_least=>9)
  )
end
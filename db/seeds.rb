# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
    email: "sample01@gmail.com",
    password: "sample01",
    nickname: "sample01",
    gender: 0
)

UserInformation.create(
    user_id: 100,
    family_name: "サン",
    given_name: "プル",
    family_name_kana: "サン",
    given_name_kana: "プル",
    birth_date: "2000-12-12"
)



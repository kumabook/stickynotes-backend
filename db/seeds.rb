# coding: utf-8

user = User.first_or_create(email: 'stickynotes@gmail.com',
                             type: User.types[:admin],
                         password: 'stickynotes',
            password_confirmation: 'stickynotes')

puts "Create admin user as id: #{user.id}"

page = user.pages.first_or_create(title: "Kのこと",
                                    url: "http://steps.dodgson.org/bn/2007/11/03/")

puts "Create sample page #{page.url}"


sticky = page.stickies.first_or_create(width: 0,
                                      height: 0,
                                        left: 0,
                                         top: 0,
                                     content: "Sample content",
                                     user_id: user.id)
tag = sticky.tags.first_or_create(name: "favorite", user_id: user.id)

puts "Create sample tag #{tag.name}"

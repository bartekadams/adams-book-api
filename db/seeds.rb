require 'faker'

Faker::Config.locale = :pl

rand = Random.new

puts 'seeding users'
puts '.' * 10
(1..10).each do |n|
    name = Faker::Name.first_name
    User.create(
        username: name,
        password: "password",
        password_confirmation: "password"
    )
    n == 10 ? (print ".\n") : (print ".")
end

puts 'seeding books'
puts '.' * 10
User.all.each do |user|
    (1..5).each do |n|
        # added slash at the end because url redirects and couses book creation to fail
        # you can do user.errors.inspect to see that if there is no slash
        url = Faker::LoremPixel.image("700x1000", false, 'abstract') + '/'
        user.books.create(
            name: Faker::Book.title,
            remote_book_cover_url: url,
            author: Faker::Book.author,
            genre: Faker::Book.genre,
            description: Faker::Hipster.paragraph(15),
            publisher: Faker::Book.publisher,
            publication_date: rand.rand(1900..2018)
        )
    end
    print "."
end
print ".\n"

puts 'seeding loans as borrower'
puts '.' * 50
(1..50).each do |n|
    Loan.create(
        book_id: rand.rand(1..50),
        borrower_id: rand.rand(1..10)
    )
    n == 50 ? (print ".\n") : (print ".")
end
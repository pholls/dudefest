# Create initial users, the magnificent 7
def populate_users
  # 1 - jkennedy
  User.create(username: 'jkennedy', email: 'joseph.stephen.kennedy@gmail.com',
              password: 'birdsdontfly', password_confirmation: 'birdsdontfly',
              role: 'admin', name: 'Joe Kennedy')
  # 2 - efinkle
  User.create(username: 'efinkle', email: 'evanfinkle@gmail.com',
              password: 'thefinkler', password_confirmation: 'thefinkler',
              role: 'reviewer', name: 'Evan Finkle')
  # 3 - dsorensen
  User.create(username: 'dsorensen', email: 'd.smigoversen@gmail.com',
              password: 'maceoparker', password_confirmation: 'maceoparker',
              role: 'editor', name: 'Dylan Sorensen')
  # 4 - jmcloughlin
  User.create(username: 'jmcloughlin', email: 'joe.mcloughlin15@gmail.com',
              password: 'henryhenryhenry', name: 'Joe McLoughlin',
              password_confirmation: 'henryhenryhenry', role: 'writer')
  # 5 - bkraus
  User.create(username: 'bkraus', email: 'bourkekraus@gmail.com',
              password: 'brotastic', password_confirmation: 'brotastic',
              role: 'editor', name: 'Bourke Kraus')
  # 6 - rkoella
  User.create(username: 'rkoella', email: 'rdkoella@gmail.com',
              password: 'mustacheride', password_confirmation: 'mustacheride',
              role: 'writer', name: 'Ryan Koella')
  # 7 - pholland
  User.create(username: 'pholland', email: 'patrick.holland3576@gmail.com',
              password: 'gaytwins', password_confirmation: 'gaytwins',
              role: 'reviewer', name: 'Pat Holland')
  puts 'Created the seven users'
end

# Create movie genres
def populate_genres
  genres = ['Rampage', 'Bromance', 'Heist', 'Gangster', 'War', 'Western',
            'Escape', 'Survival', 'Quest', 'Sports', 'Comedy', 'Space',
            'Post-Apocalypse', 'Spy', 'Superhero', 'Jason Statham',
            'Wildcard', 'None']
  genres.each do |g|
    Genre.create(genre: g)
  end
  puts 'Added movie genres'
end

# Create thing categories
def populate_thing_categories
  categories = ['Athletics', 'Exercise', 'Food', 'Drinks', 'People', 'Animals',
                'Hair', 'Characters', 'Activities', 'Professions', 'Movies',
                'Clothing', 'Transportation', 'Places', 'Bands', 'TV Shows',
                'Organizations', 'Songs', 'Extreme Sports', 'Brands' ]
  categories.each do |c|
    ThingCategory.create(category: c)
  end
  puts 'Added thing categories'
end

# Create columns
def populate_columns
  Column.create(column: 'Other', short_name: 'Other')
  Column.create(column: 'Movie Reviews', short_name: 'Cinema',
                default_image: '/film-reel.jpg', days_between_posts: 1)
  Column.create(column: 'Beer And Shit', short_name: 'Booze', columnist_id: 3,
                default_image: '/beer-mug.jpg', days_between_posts: 4)
  Column.create(column: 'Excellent Life Advice From Jimmy Fraturday', 
                short_name: 'Frat', columnist_id: 5, 
                default_image: '/greek-letters.jpg', days_between_posts: 4)
  puts 'Added columns'
end

# Create models configuration
def populate_models
  launch = Date.strptime('01/15/14', '%m/%d/%y')
  article_start = Date.strptime('01/01/14', '%m/%d/%y')
  Model.create(model: 'Tip', owner_id: 5, start_date: launch)
  Model.create(model: 'Event', owner_id: 1, start_date: launch)
  Model.create(model: 'DailyVideo', owner_id: 7, start_date: launch)
  Model.create(model: 'Thing', owner_id: 3, start_date: launch)
  Model.create(model: 'Position', owner_id: 2, start_date: launch)
  Model.create(model: 'Article', owner_id: 3, start_date: article_start)
  Model.create(model: 'Rating', owner_id: 3, start_date: article_start)
  puts 'Added models configuration'
end

populate_users
populate_genres
populate_thing_categories
populate_columns
populate_models

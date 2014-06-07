u = User.find_or_initialize_by_email("guest@example.com")
u.full_name = "Guest User" if u.new_record?
u.password = "password"
u.save!

file = File.join(Rails.root, 'db', 'videos_seed.yml')
categorized_videos = YAML::load(File.open(file))

categorized_videos.each do |video|
  cat = Category.find_or_create_by_name(video[:category])

  vid = Video.find_or_initialize_by_title(video[:title])
  next unless vid.new_record?

  vid.attributes = {
    description: video[:description],
    remote_small_cover_url: video[:remote_small_cover_url],
    remote_large_cover_url: video[:remote_large_cover_url],
    category: cat,
    year: video[:year],
    cert_rating: video[:cert_rating],
    duration: video[:duration]
  }

  next unless vid.save

  if video[:creators]
    video[:creators].each do |creator|
      c = Artist.find_or_create_by_name(creator)
      vid.creators << c
    end
  end

  if video[:cast]
    video[:cast].each do |actor|
      a = Artist.find_or_create_by_name(actor)
      vid.actors << a
    end
  end

  reviews = video[:reviews]

  if reviews
    users = User.all.sample(reviews.count)
    reviews.each_with_index do |review, index|
      user = users[index]
      if review[:content]
        Review.create(
          content: review[:content],
          user: user,
          video: vid
        )
      end

      if review[:rating]
        Rating.create(
          value: review[:rating],
          user: user,
          video: vid
        )
      end
    end
  end
end

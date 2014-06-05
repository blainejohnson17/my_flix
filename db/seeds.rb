Video.destroy_all
Category.destroy_all
User.destroy_all
u = User.create(full_name: "Blaine Johnson", email: "blainejohnson17@gmail.com", admin: true)
u.password = "password"
u.save!

file = File.join(Rails.root, 'db', 'videos_seed.yml')
categorized_videos = YAML::load(File.open(file))

categorized_videos.each do |video|
  cat = Category.find_or_create_by_name(video[:category])
  vid = Video.create(
    title: video[:title],
    description: video[:description],
    remote_small_cover_url: video[:remote_small_cover_url],
    remote_large_cover_url: video[:remote_large_cover_url],
    category: cat,
    year: video[:year],
    cert_rating: video[:cert_rating],
    duration: video[:duration]
  )

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

  if video[:reviews]
    video[:reviews].each do |review|
      user = Fabricate(:user)
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

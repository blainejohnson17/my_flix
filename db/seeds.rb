file = File.join(Rails.root, 'db', 'tv_shows_1364.yml')
categorized_videos = YAML::load(File.open(file))

# categorized_videos.each do |category|
#   cat = category.find_or_create_by_name(category[:name])
  cat = Category.find_or_create_by_name('TV Shows')

  categorized_videos.each do |video|
    vid = Video.create(
      title: video[:title],
      description: video[:description],
      remote_small_cover_url: video[:remote_small_cover_url],
      remote_large_cover_url: video[:remote_large_cover_url],
      category: cat
    )

    video[:reviews].each do |review|
      user = Fabricate(:user)
      Review.create(
        content: review[:content],
        user: user,
        video: vid
      )
      Rating.create(
        value: review[:rating],
        user: user,
        video: vid
      )
    end
  end
# end

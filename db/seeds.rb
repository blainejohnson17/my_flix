# comedy = Category.create(name: "TV Comedy")
# drama = Category.create(name: "TV Drama")
# Category.create(name: "Reality TV")
# Video.create(title: 'Family Guy', description: "In Seth MacFarlane's no-holds-barred animated show, buffoonish Peter Griffin and his dysfunctional family -- including wife Lois, children Meg, Chris and Stewie, and dog Brian -- experience wacky misadventures.", small_cover_url: '/tmp/family_guy.jpg', large_cover_url: '/tmp/family_guy_large.jpg', category: comedy)
# Video.create(title: 'Futurama', description: "Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.", small_cover_url: '/tmp/futurama.jpg', large_cover_url: '/tmp/futurama_large.jpg', category: comedy)
# monk = Video.create(title: 'Monk', description: "With his job secure and his wife's murder finally solved, Adrian Monk is feeling strangely... satisfied. He'd like his agoraphobic brother Ambrose to feel the same way, so Monk puts a secret ingredient in Ambrose's birthday cake. When Ambrose wakes up, he's in a motor home on the open road with Monk determined to show him the outside world. But Ambrose isn't the only one struggling to let go. Now it's up to Monk to stop a murderer from turning their road trip into a highway to hell.", small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category: drama)
# Video.create(title: 'South Park', description: "Follows the misadventures of four irreverent grade-schoolers in the quiet, dysfunctional town of South Park, Colorado.", small_cover_url: '/tmp/south_park.jpg', large_cover_url: '/tmp/south_park_large.jpg', category: comedy)
# jon = User.create(email: "jon@gmail.com", full_name: "Jon Johnson", password: "password")
# blaine = User.create(email: "blaine@gmail.com", full_name: "Blaine Johnson", password: "password")
# Review.create(rating: 5, content: "Great Movie!!", video: monk, user: jon)
# Review.create(rating: 1, content: "This movie sucks!!", video: monk, user: blaine)
comedy = Category.find_or_create_name(name: "TV Comedy")
Video.create(
  title: 'The Croods',
  description: 'When an earthquake obliterates their cave, an unworldly prehistoric family is forced to journey through unfamiliar terrain in search of a new home.',
  remote_small_cover_url: "http://cdn3.nflximg.net/webp/2353/3862353.webp",
  remote_large_cover_url:"http://cdn6.nflximg.net/webp/2356/3862356.webp",
  category: comedy
)
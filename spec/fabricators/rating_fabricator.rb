Fabricator(:rating) do
  video
  user
  value { (1..5).to_a.sample }
end
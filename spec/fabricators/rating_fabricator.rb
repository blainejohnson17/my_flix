Fabricator(:rating) do
  value { (1..5).to_a.sample }
end
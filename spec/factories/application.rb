Factory.define(:application, :class => ::Application) do |a|
  a.sequence(:name) { |n| "Application #{ n }" }
  a.url { 'https://test.com' }
  a.callback_url { 'https://test.com/callback' }
  a.author { Factory(:user).actor }
end

Factory.define(:official_application, parent: :application) do |a|
  a.official true
end

Factory.define(:store, parent: :official_application) do |a|
  a.store true
end

# frozen_string_literal: true

env :PATH, ENV['PATH']

every 1.day, at: '5:00 am' do
  rake 'decidim:metrics:all'
end

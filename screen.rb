require './app/core'
File.readlines('input').each do |url|
  ScreenWorker.perform_async(url)
end
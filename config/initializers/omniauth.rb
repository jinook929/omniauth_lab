Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  # provider :github, ENV['GITHUB_ID'], ENV['GITHUB_SECRET']
  # provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], skip_jwt: true
  provider :github, Rails.application.credentials.github[:github_id], Rails.application.credentials.github[:github_secret]
  provider :google_oauth2, Rails.application.credentials.google[:google_client_id], Rails.application.credentials.google[:google_client_secret], skip_jwt: true
end 
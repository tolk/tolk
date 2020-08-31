# Add the assets for Rails 6 app
if defined?(Rails)
  Rails.application.config.assets.precompile += %w[tolk/application.js tolk/application.css]
end

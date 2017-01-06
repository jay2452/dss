Rails.configuration.middleware.use Browser::Middleware do
  # redirect_to welcome_upgrade_path unless browser.ie?
end

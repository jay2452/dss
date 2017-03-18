Delayed::Worker.max_attempts = 5
if Rails.env.development?
  Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job_development.log'))
elsif Rails.env.production?
  Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job_production.log'))
end

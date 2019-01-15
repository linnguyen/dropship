# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
    :address              => "smtp.sendgrid.net",
    :domain               => DOMAIN,
    :user_name            => ENV['SENDGRID_USERNAME'],
    :password             => ENV['SENDGRID_PASSWORD'],
    :authentication       => "plain",
    :enable_starttls_auto => true
}
ActionMailer::Base.default_url_options = { host: '157.230.60.184' }

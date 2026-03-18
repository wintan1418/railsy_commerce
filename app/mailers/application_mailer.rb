class ApplicationMailer < ActionMailer::Base
  default from: -> { StoreConfig.get("store_email", "hello@railsycommerce.com") }
  layout "mailer"
end

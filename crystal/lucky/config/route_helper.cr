# This is used when generating URLs for your application
Lucky::RouteHelper.configure do |settings|
  # Set domain to the default host/port in development
  settings.base_uri = "http://localhost:3001"
end

Rails.application.configure do
  config.enable_reloading = true # Auto-reload code changes
  config.eager_load = false # Load classes when needed, false for faster test startup
  config.consider_all_requests_local = true # Show detailed errors
  
  config.active_record.verbose_query_logs = true # Show SQL queries with caller info
end
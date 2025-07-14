Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Allow Vite dev server - restrict to localhost for security
    origins "http://localhost:5173"

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ["Authorization"] # Allow frontend to read JWT from responses
  end
end
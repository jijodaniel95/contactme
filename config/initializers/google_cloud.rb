# Configure Google Cloud authentication for different environments

# Default path for credentials
credentials_path = Rails.root.join("config", "your-key.json")

# Check if we need to use a different path based on environment
if Rails.env.development?
  dev_credentials_path = Rails.root.join("config", "/Users/jijodaniel/Downloads/aerial-bonfire-462121-i9-20754997ff67.json")
  credentials_path = dev_credentials_path if File.exist?(dev_credentials_path)
elsif Rails.env.test?
  test_credentials_path = Rails.root.join("config", "/Users/jijodaniel/Downloads/aerial-bonfire-462121-i9-20754997ff67.json")
  credentials_path = test_credentials_path if File.exist?(test_credentials_path)
end

# Set the credentials path if the file exists
if File.exist?(credentials_path)
  ENV["GOOGLE_APPLICATION_CREDENTIALS"] = credentials_path.to_s
  Rails.logger.info("Google Cloud credentials loaded from: #{credentials_path}")
else
  Rails.logger.warn("Google Cloud credentials file not found at: #{credentials_path}")
  
  # For development/test, we'll create a minimal mock credential file
  if Rails.env.development? || Rails.env.test?
    mock_credentials_path = Rails.root.join("config", "mock_credentials.json")
    unless File.exist?(mock_credentials_path)
      # Create a minimal mock credential file
      File.open(mock_credentials_path, "w") do |file|
        file.write('{"type":"service_account","project_id":"mock-project"}')
      end
    end
    
    ENV["GOOGLE_APPLICATION_CREDENTIALS"] = mock_credentials_path.to_s
    Rails.logger.info("Using mock Google credentials for #{Rails.env} at: #{mock_credentials_path}")
  end
end 
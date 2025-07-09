require "google/cloud/pubsub"
class ContactFormPublisher
    # Topic name
    TOPIC_NAME = "contact-me"
    
    def publish(full_name, email, subject, message)
        begin
            pubsub = Google::Cloud::Pubsub.new
            
            # Get or create the topic
            topic = get_or_create_topic(pubsub)
            
            payload = {
                fullName: full_name,
                email: email,
                subject: subject,
                messageText: message
            }.to_json
            
            Rails.logger.info("Publishing to Pub/Sub topic: #{TOPIC_NAME}")
            Rails.logger.info("Payload: #{payload}")
            
            message_id = topic.publish_async(payload) do |result|
                if result.succeeded?
                    Rails.logger.info("Message published with ID: #{result.message_id}")
                else
                    Rails.logger.error("Failed to publish message: #{result.error}")
                end
            end
            
            Rails.logger.info("Message queued with ID: #{message_id}")
            true
        rescue => e
            Rails.logger.error("Error publishing to Pub/Sub: #{e.message}")
            Rails.logger.error(e.backtrace.join("\n"))
            raise e
        
        end
    end
    
    private
    
    def get_or_create_topic(pubsub)
        # Check if topic exists
        topic = pubsub.topic TOPIC_NAME
        
        # Create the topic if it doesn't exist
        if topic.nil?
            Rails.logger.info("Topic '#{TOPIC_NAME}' not found, creating...")
            topic = pubsub.create_topic TOPIC_NAME
            Rails.logger.info("Topic '#{TOPIC_NAME}' created successfully")
        end
        
        topic
    end
    
    def fallback_publish(full_name, email, subject, message)
        payload = {
            fullName: full_name,
            email: email,
            subject: subject,
            messageText: message
        }
        
        Rails.logger.info("DEVELOPMENT MODE: Would have sent to Pub/Sub:")
        Rails.logger.info(payload.to_json)
        Rails.logger.info("Mock message ID: mock-#{Time.now.to_i}")
    end
end
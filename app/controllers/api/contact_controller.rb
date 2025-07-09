module Api
  class ContactController < ApplicationController
    skip_before_action :verify_authenticity_token
    
    # POST /api/contacts
    def create
      # Validate required parameters
      unless valid_params?(params)
        return render json: { status: "error", errors: missing_params }, status: :bad_request
      end
      
      begin
        # Publish to PubSub
        publisher = ContactFormPublisher.new
        success = publisher.publish(
          params[:full_name] || params[:fullName],
          params[:email],
          params[:subject],
          params[:message] || params[:messageText]
        )
        
        if success
          # Log successful request
          Rails.logger.info("Contact form submitted successfully")
          render json: { status: "success", message: "Message sent successfully" }, status: :ok
        else
          render json: { status: "error", message: "Failed to send message" }, status: :internal_server_error
        end
      rescue => e
        # Log error
        Rails.logger.error("Error in contact controller: #{e.message}")
        render json: { status: "error", message: e.message }, status: :internal_server_error
      end
    end
    
    # GET /api/contacts/:id
   
    private
    
    def valid_params?(params)
      name = params[:full_name].present? || params[:fullName].present?
      email = params[:email].present?
      subject = params[:subject].present?
      message = params[:message].present? || params[:messageText].present?
      
      name && email && subject && message
    end
    
    def missing_params
      errors = []
      errors << "Name is required" unless params[:full_name].present? || params[:fullName].present?
      errors << "Email is required" unless params[:email].present?
      errors << "Subject is required" unless params[:subject].present?
      errors << "Message is required" unless params[:message].present? || params[:messageText].present?
      errors
    end
  end
end 
module Api
  class HealthController < ApplicationController
    skip_before_action :verify_authenticity_token

    # GET /api/health
    def index
      render json: {
        status: "ok",
        message: "API is up and running",
        version: "1.0",
        timestamp: Time.current.iso8601
      }, status: :ok
    end
  end
end

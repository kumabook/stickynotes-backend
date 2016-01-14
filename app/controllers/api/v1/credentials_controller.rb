class Api::V1::CredentialsController < Api::V1::ApiController
  before_action :doorkeeper_authorize!
  respond_to    :json

  # GET /me.json
  def me
    respond_with current_resource_owner
  end

end

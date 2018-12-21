class HealthcheckController < ApplicationController
  def ping
    render text:'ok'
  end
end

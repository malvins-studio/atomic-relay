class JobsController < ApplicationController
  skip_forgery_protection

  def create
    data = JSON.parse(request.body.read)
    SendJob.perform_later(data)

    render json: { status: "queued" }
end

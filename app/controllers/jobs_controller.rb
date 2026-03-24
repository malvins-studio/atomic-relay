class JobsController < ApplicationController
  skip_forgery_protection

  def create
    data = JSON.parse(request.body.read)

    puts "[ENQUEUE] #{data}"
    SendJob.perform_later(data)

    render json: { status: "queued" }
  end
end

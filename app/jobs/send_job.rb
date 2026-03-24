class SendJob < ApplicationJob
  queue_as :default

  def perform(*args)
    WebSocketHub.send_to(args[device_id], {
      type: "job",
      id: args["id"],
      adapter: args["adapter"],
      payload: args["payload"]
    })
  end
end

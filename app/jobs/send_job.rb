class SendJob < ApplicationJob
  queue_as :default

  def perform(*data)
    data = data.first if data.is_a?(Array)

    data = data.transform_keys(&:to_s)

    puts "[JOB] Sending to #{data['device_id']} | id=#{data['id']}"

    WebsocketHub.send_to(data["device_id"], {
      type: "job",
      id: data["id"],
      adapter: data["adapter"],
      payload: data["payload"]
    })

    puts "[JOB] Dispatched id=#{data['id']}"
  end
end

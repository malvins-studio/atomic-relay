module WebSocketHub
  CLIENTS = {}

  def self.register(device_id, ws)
    CLIENTS[device_id] = ws
  end

  def self.unregister(device_id)
    CLIENTS.delete(device_id)
  end

  def self.send_to(device_id, payload)
    ws = CLIENTS[device_id]
    raise "Device not connected." unless ws

    ws.send(payload.to_json)
  end
end

require Rails.root.join("app/services/websocket_server")

Rails.application.config.middleware.use WebsocketServer

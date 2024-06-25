class ChatJob < ApplicationJob
  self.queue_adapter = :solid_queue
  limits_concurrency to: 1, key: ->(device_id) { device_id }

  def perform(device_id)
    device = Device.find(device_id)
    device.fetch_messages!
  end
end

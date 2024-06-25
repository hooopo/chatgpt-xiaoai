class TestJob < ApplicationJob
  self.queue_adapter = :solid_queue
  limits_concurrency to: 1, key: ->(arg) { "1" }
  def perform(arg)
    Device.all.each do |device|
      next if not device.tts_support?
      ChatJob.perform_later(device.device_id)
    end
  end
end

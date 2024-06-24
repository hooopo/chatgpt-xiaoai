class TestJob < ApplicationJob
  self.queue_adapter = :solid_queue

  def perform(arg)
    Device.all.each do |device|
    end
  end
end

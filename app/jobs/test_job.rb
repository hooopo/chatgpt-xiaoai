class TestJob < ApplicationJob
  self.queue_adapter = :solid_queue
end

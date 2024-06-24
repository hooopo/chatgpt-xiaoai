class PullMessageJob < ApplicationJob
  self.queue_adapter = :solid_queue

  def perform(arg)
  end
end

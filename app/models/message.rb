class Message < ApplicationRecord
  belongs_to :device
  belongs_to :account

  after_create :generate_llm_response

  def generate_llm_response
    return if role == "gpt"
    response = device.llm.chat(
      parameters: {
          model: "gpt-4o", # Required.
          messages: [ { role: "user", content: query } ], # Required.
          temperature: 0.7
    })
    answer_text = response.dig("choices", 0, "message", "content")
    device.messages.create(
      account_id: account_id,
      time: Time.now.to_f * 1000,
      query: answer_text,
      role: "gpt",
      request_id: request_id + "_gpt"
    )
    device.tts_cmd(answer_text)
  end
end

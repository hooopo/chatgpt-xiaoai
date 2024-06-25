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

    # loop until device.playing? == false

    loop do
      playing = device.playing?
      break if not playing
      puts "playing..."
      sleep 1
    end
    device.text_to_speech("正在召唤 ChatGPT 帮你解答，请耐心等待...")
    # device.tts_cmd(answer_text)
    device.text_to_speech(answer_text)

    device.messages.create(
      account_id: account_id,
      time: Time.now.to_f * 1000,
      query: answer_text,
      role: "gpt",
      request_id: request_id + "_gpt"
    )
  end
end

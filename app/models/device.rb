class Device < ApplicationRecord
  belongs_to :account

  has_many :messages

  def llm
    @client ||= OpenAI::Client.new(
      access_token: ENV["OPENAI_API_KEY"],
      uri_base: "https://openrouting.dev",
      request_timeout: 240,
      extra_headers: {
        "X-X" => "test"
      }
    )
  end

  def tts_support?
    HARDWARE_CMD.keys.include?(hardware)
  end

  def latest_messages(limit: 2)
    account.service.message_list(
      device_id: device_id,
      hardware: hardware,
      limit: limit
    )
  end

  def text_to_speech(text)
    account.service.text_to_speech(
      device_id,
      text
    )
  end

  def tts_cmd(text)
    account.service.miot_action(
      miot_did,
      HARDWARE_CMD[hardware][0],
      text
    )
  end

  def player_pause
    account.service.player_pause(device_id)
  end

  def player_stop
    account.service.player_stop(device_id)
  end

  def player_get_status
    account.service.player_get_status(device_id)
  end

  def fetch_messages!
    data = latest_messages(limit: 2)["data"]
    records = JSON.parse(data)["records"]
    records.each do |record|
      attrs = {
        time: record["time"],
        query: record["query"],
        request_id: record["requestId"]
      }

      unless messages.where(request_id: record["requestId"]).first
        self.messages.create(attrs.merge(
          account_id: account_id,
          role: "user"
        ))
      end
    end
  end
end

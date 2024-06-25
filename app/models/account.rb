class Account < ApplicationRecord
  has_many :devices
  has_many :messages

  belongs_to :default_device, optional: true

  def service
    @service ||= Mi::Service::Account.new(user_id, password, debug: true)
    @service.login_from_data(authenticated_data)
    @service
  end

  def relogin
    @service = Mi::Service::Account.new(user_id, password, debug: true)
    @service.login_all
    update(authenticated_data: @service.info)
  end

  def create_devices_from_service(list)
    list.each do |d|
      attrs = {
        device_id: d["deviceID"],
        serial_number: d["serialNumber"],
        name: d["name"],
        alias: d["alias"],
        current: d["current"],
        presence: d["presence"],
        address: d["address"],
        miot_did: d["miotDID"],
        hardware: d["hardware"],
        rom_version: d["romVersion"],
        capabilities: d["capabilities"],
        remote_ctrl_type: d["remoteCtrlType"],
        device_sn_profile: d["deviceSNProfile"],
        device_profile: d["deviceProfile"]
      }

      if device = self.devices.where(device_id: d["deviceID"]).first
        device.update(attrs)
      else
        self.devices.create(attrs)
      end
    end
  end
end

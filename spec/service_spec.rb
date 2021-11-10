require_relative '../service.rb'

describe 'Time Service' do
  context "#add_minutes" do

    it "should return added time" do
      service = TimeService::TimeOutputter.new do |service|
        service.starting_time = '9:13 AM'
        service.minutes_to_add = 10
      end
      expect(service.add_minutes).to eq("9:23 AM")
    end
  end

  context "validations" do
    # Do stuff here
  end
end

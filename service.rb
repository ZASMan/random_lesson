
module TimeService
  class TimeSplitter
    attr_accessor :starting_time, :minutes_to_add, :starting_minutes, :ending_minutes, :ending_hours, :starting_hours, :ending_time, :morning_or_night

    AM_PM_VALUES = ['AM', 'PM']

    def add_minutes(starting_time = @starting_time, minutes_to_add = @minutes_to_add)
      if @minutes_to_add >= 60
        @ending_hours = starting_hours + (minutes_to_add / 60)
        minutes_to_add_result = nil
        until minutes_to_add_result.is_a?(Integer) && minutes_to_add_result / 60 == 0
          minutes_to_add = minutes_to_add - 60
          minutes_to_add_result = minutes_to_add
        end
      else
        @ending_hours = starting_hours
        minutes_to_add_result = (@starting_minutes.to_i + minutes_to_add.to_i).to_s
      end
      if @ending_hours > 12
        @ending_hours = starting_hours
        @ending_hours = @ending_hours - 12
        @morning_or_night = shift_hours
      end
      @ending_minutes = minutes_to_add_result
      @ending_time = "#{@ending_hours}:#{ending_minutes} #{morning_or_night}"
    end

    def validate_input_data
      raise("starting_time must be a string") unless starting_time.is_a?(String)
      raise("Format must be like '9:13 AM' or '10:13 PM'") unless starting_time.length == 7 || starting_time.length == 8
      if starting_time.length == 7
        raise("Must contain colon between hours and minutes") unless starting_time[1] == ":"
        raise("First value must be an hour from 1-9") unless (0..9).to_a.map(&:to_s).include?(starting_time[0])
        raise("Last values must be AM or PM") unless AM_PM_VALUES.include?((starting_time[5] + starting_time[6]))
        @starting_hours = starting_time[0].to_i
        @morning_or_night = starting_time[5] + starting_time[6]
      elsif starting_time.length == 8
        raise("Must contain colon between hours and minutes") unless starting_time[2] == ":"
        raise("First value must be an hour from 10-12") unless (10..12).to_a.map(&:to_s).include?(starting_time[0] + starting_time[1])
        raise("Last values must be AM or PM") unless AM_PM_VALUES.include?(starting_time[6] + starting_time[7])
        @starting_hours = (starting_time[0] + starting_time[1]).to_i
        @morning_or_night = starting_time[6] + starting_time[7]
      else
        raise("Format must be like '9:13 AM' or '10:13 PM'")
      end
      raise("minutes_to_add must be integer") unless minutes_to_add.is_a?(Integer)
      @minutes_to_add = minutes_to_add
      @starting_time = starting_time
      @minutes_to_add = minutes_to_add
      if starting_time.length == 7
        @starting_minutes = (starting_time[2] + starting_time[3]).to_i
        @sarting_hours = starting_time[0].to_i
      elsif starting_time.length == 8
        @starting_minutes = (starting_time[3] + starting_time[4]).to_i
        @sarting_hours = (starting_time[0] + starting_time[1]).to_i
      end
    end

    def shift_hours
      AM_PM_VALUES.detect { |value| value != @morning_or_night }
    end
  end
end

module TimeService
  class TimeOutputter < TimeService::TimeSplitter
    attr_accessor :starting_time, :minutes_to_add, :starting_minutes, :ending_minutes, :ending_hours, :starting_hours, :ending_time, :morning_or_night

    def initialize(&block)
      instance_eval(&block)
      validate_input_data
    end
  end
end

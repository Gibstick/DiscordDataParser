require 'tzinfo'

class SessionProcessor
    def initialize
        @active_sessions = {}
        @total_session_length = 0
        @total_session_length_by_os = Hash.new(0)
        @total_session_length_by_location = Hash.new(0)
        @total_session_length_by_device = Hash.new(0)
        @timezone_offsets_by_day = Hash.new
        @total_sessions = 0
        @total_app_open = 0
    end

    def process(activity, event_type)
        return unless ['session_end', 'session_start', 'app_opened'].include? event_type
        if event_type == 'app_opened'
            @total_app_open += 1
            return
        end
        if event_type == 'session_start'
            @total_sessions += 1
            @active_sessions[activity['session']] ||= {}
            @active_sessions[activity['session']]['start'] = activity['timestamp']
        elsif event_type == 'session_end'
            @active_sessions[activity['session']] ||= {}
            @active_sessions[activity['session']]['end'] = activity['timestamp']
        end

        if @active_sessions[activity['session']]['start'] && @active_sessions[activity['session']]['end']
            session_start = Time.parse(@active_sessions[activity['session']]['start'])
            session_end = Time.parse(@active_sessions[activity['session']]['end'])
            @active_sessions.delete(activity['session'])

            session_length = ((session_end - session_start) / 60).round(2)
            @total_session_length += session_length
            @total_session_length_by_os[activity['os']] += 1
            timezone_offset = TZInfo::Timezone.get(activity['time_zone']).current_period.offset.utc_total_offset if activity['time_zone']
            @timezone_offsets_by_day[activity['timestamp'][0, 10]] ||= timezone_offset
            @total_session_length_by_location["#{activity['city'] || 'unknown'}:#{activity['region_code'] || 'unknown'}:#{activity['country_code'] || 'unknown'}"] += 1
            @total_session_length_by_device[activity['device'] || activity['os'] || 'unknown'] += 1 # no device information for desktop users, default to OS
        end
    end

    def output
        {
            time_by_os: @total_session_length_by_os.sort_by { |_os, count| count }.reverse,
            time_by_location: @total_session_length_by_location.sort_by { |_location, count| count }.reverse,
            time_by_device: @total_session_length_by_device.sort_by { |_device, count| count }.reverse,
            total_sessions: @total_sessions,
            total_app_open: @total_app_open,
            average_session_length: (@total_session_length / @total_sessions).round(2),
            timezone_offsets_by_day: @timezone_offsets_by_day
        }
    end
end

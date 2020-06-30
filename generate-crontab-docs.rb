#!/usr/bin/env ruby

require 'logger'

require_relative "cronentry"

logger = Logger.new(STDOUT)

# generate-crontab-docs
# take cron job list for cid nodes and order by time ascending:
# => Minute/Hourly
# => Daily
# => etc.

@cron_entries = []

# accept input from file or pipe
while input = ARGF.gets
  input.each_line do |line|

    # 1. clean leading/trailing whitespace
    line = line.chomp.strip.squeeze(" ")
    
    # 2. ignore lines that start with comment
    if (!line.empty? and line[0] != "#") then

      # collect the parts we need to hydrate a cron entry object      
      re = /(\S{1,4})\s(\S{1,4})\s(\S{1,4})\s(\S{1,4})\s(\S{1,4})\s(\S.*$)/
      line =~ re

      # 3. parse line into cron entry object & store in an array
      @cron_entries << CronEntry.new($1.to_s, $2.to_s, $3.to_s, $4.to_s, $5.to_s, $6.to_s)

      logger.info("Created entry: #{$1} #{$2} #{$3} #{$4} #{$5}")
    end
    
  end

end

# 4. order collection - ascending (minutes before hours before days, etc.)
@sorted_cron_entries = @cron_entries.sort

# Currently an issue with the sorting - does not end up in intended order!!!
#for i in 0 .. 999
#  @sorted_cron_entries = @sorted_cron_entries.sort
#end

# 5. output collection in documentation format
@sorted_cron_entries.each do |entry|
  puts entry
end


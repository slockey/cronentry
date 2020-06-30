# represents a registeredt cron task
require 'logger'

class CronEntry

  attr_accessor :minute, :hour, :day, :month, :week, :command

  attr_accessor :logger

  def initialize(minute, hour, day, month, week, command)
    @minute = minute
    @hour = hour
    @day = day
    @month = month
    @week = week
    @command = command
    @logger = Logger.new(STDOUT)
  end

# a <=> b :=
#  if a < b then return -1
#  if a = b then return  0
#  if a > b then return  1
#  if a and b are not comparable then return nil
  def <=>(other)

    # note: right-most time value is always weighted higher
    #       moving right to left provides more precision
    #       on the sort order where:
    # =>    minute is highest precision and week is lowest
    # however, there is an effect of right to left eval where
    # minute 5 is less than minute 4 if an hour value is specified (even 0)

    # day of week: 1-7 x 100000
    # month: 1-12 x 10000
    # day of month: 1-31 x 1000
    # hour: 0-23 x 100
    # minute: 0-59 x 1

    begin
      # compare minute
      selfVal = getWeightedValue(self.minute, 1)
      otherVal = getWeightedValue(other.minute, 1)
      # compare hour
      selfVal += getWeightedValue(self.hour, 100)
      otherVal += getWeightedValue(other.hour, 100)
      # compare day of month
      selfVal += getWeightedValue(self.month, 1000)
      otherVal += getWeightedValue(other.month, 1000)
      # compare month
    rescue
      logger.error("Caught exception - #{self} : #{other}")
    end

    logger.info("Cron entry comparison: comp #{selfVal <=> otherVal} self #{selfVal} other #{otherVal}")

    return selfVal <=> otherVal

  end

  def getWeightedValue(val, modifier=1)
    weightedVal = 0

    val = val.chomp.strip.squeeze(" ")

    # */n => n
    # n => n
    # * => -1
    if val.start_with?("*/") then
      weightedVal = val[2..-1].to_i
     elsif val.eql?("*")
       weightedVal = -1
     else
       weightedVal = val.to_i
    end

    return weightedVal * modifier
  end

  def to_s
    "#@minute #@hour #@day #@month #@week #@command"
  end
end
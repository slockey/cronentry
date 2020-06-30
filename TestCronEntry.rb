require_relative 'cronentry'
require "test/unit"

class TestCronEntry < Test::Unit::TestCase

  EXPECTED_ENTRIES = { 0 => "0 * * * * Command 0", 
                       1 => "1 * * * * Command 1", 
                       2 => "2 * * * * Command 2", 
                       3 => "3 * * * * Command 3", 
                       4 => "4 * * * * Command 4" }

  # Test - ordered originating data
  def test_minute_sort_already_ordered
    @expectedIds = [0,1,2,3,4]
    @cronEntries = []
    
    @expectedIds.each do |value|
      @cronEntries << CronEntry.new(value.to_s,"*","*","*","*","Command #{value}")
    end

    # apply custom ordering as implemented in def <=>(other)
    @sorted = @cronEntries.sort

    assert_equal(5, @sorted.length)

    EXPECTED_ENTRIES.each do |id, str|
      assert_equal(str, @sorted[id].to_s)
    end
  end

  # Test - unordered originating data
  def test_minute_sort_unordered
    @expectedIds = [0,2,1,4,3]
    @cronEntries = []
    
    @expectedIds.each do |value|
      @cronEntries << CronEntry.new(value.to_s,"*","*","*","*","Command #{value}")
    end

    # apply custom ordering as implemented in def <=>(other)
    @sorted = @cronEntries.sort
    assert_equal(5, @sorted.length)

    EXPECTED_ENTRIES.each do |id, str|
      assert_equal(str, @sorted[id].to_s)
    end
  end

  EXPECTED_MIN_HR_ENTRIES = { 0 => "5 * * * * Command 5", 
                       1 => "1 0 * * * Command 1", 
                       2 => "2 0 * * * Command 2", 
                       3 => "3 0 * * * Command 3", 
                       4 => "4 0 * * * Command 4", 
                       5 => "0 1 * * * Command 6" }

  def test_minute_hour_sort
    @cronEntries = []

    @cronEntries << CronEntry.new("0","1","*","*","*","Command 6")
    @cronEntries << CronEntry.new("2","0","*","*","*","Command 2")
    @cronEntries << CronEntry.new("1","0","*","*","*","Command 1")
    @cronEntries << CronEntry.new("3","0","*","*","*","Command 3")
    @cronEntries << CronEntry.new("5","*","*","*","*","Command 5")
    @cronEntries << CronEntry.new("4","0","*","*","*","Command 4")

    # apply custom ordering as implemented in def <=>(other)
    @sorted = @cronEntries.sort
    assert_equal(6, @sorted.length)

    # testing -> output list
    @sorted.each do |entry|
      puts entry.to_s
    end

    EXPECTED_MIN_HR_ENTRIES.each do |id, str|
      assert_equal(str, @sorted[id].to_s)
    end

  end

end

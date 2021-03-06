require 'helper'
require 'classifer'

class ClassiferTest < Test::Unit::TestCase
  def training_examples(close=0)
    %w[ AAPL QQQ ].inject({}) do |examples,ticker|
      examples[ticker] = {
        '2012-01-01 09:30:00' => {
          :open => 60.0, :high => 60.0, :low => 60.0, :close => 60.0 },
        '2012-01-01 09:31:00' => {
          :open => 60.0, :high => 60.0, :low => 60.0, :close => 60.0+close }
      }
      examples
    end
  end
  
  def trained_examples(close_change=0)
    Classifer.new('QQQ', training_examples(close_change)).trained_examples
  end
  
  def assert_classified(classification, bar)
    assert_equal classification, bar[:classification]
  end
  
  test "not long" do
    assert_classified nil, trained_examples.first
    assert_classified nil, trained_examples.last
    assert_classified nil, trained_examples(0.04).last
  end
  
  test "long" do
    assert_classified :long, trained_examples(0.05).last
  end
  
  test "not short" do
    assert_classified nil, trained_examples(-0.04).last
  end
  
  test "short" do
    assert_classified :short, trained_examples(-0.05).last
  end
  
  test "use percentage change for distance calculation" do
    examples = Classifer.new('QQQ', training_examples(0.05)).trained_examples
    assert_in_delta 0.00083, examples.last['AAPL'], 0.001
  end
end
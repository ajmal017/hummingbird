require 'bracket_order'

class OrderPlacement < Gateway
  attr_reader :ticker, :realtime_data
  
  def initialize(ticker, realtime_data)
    @ticker, @realtime_data = ticker, realtime_data
    super()
  end
  
  def update(position)
    BracketOrder.new(position, ticker, self, current_ask).place_orders
  end
  
  def current_ask
    realtime_data.current_ask ticker # 5s old - could miss the market
  end
  
  def orderStatus(order_id, status, filled, remaining, avgFillPrice, permId,
      parentId, lastFillPrice, clientId, whyHeld)
  end
  
  def execDetails(request_id, contract, execution)
  end
end

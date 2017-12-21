class EventStore
  include Singleton

  def initialize
    @events = []
  end

  def pushEvent(e)
    @events.push(e)
  end

  def clearEvents
    @events = []
  end

  def getEvents
    @events
  end
end

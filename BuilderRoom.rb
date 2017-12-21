require_relative 'BaseRoom'

class BuilderRoom < BaseRoom
  def initialize(hill)
    super(hill, Ant::TYPE_BUILDER)
  end

  def produceAnt
    ant = Ant.new(hill.colony, ant_type)
    class << ant
      def processTurn
        hill = Meadow.instance.getAnthillForColony(colony)
        if hill.food > 0 && hill.strategy.hasNext
          room_to_construct = hill.strategy.next
          hill.addRoom(room_to_construct)
          hill.consumeFood(1)
          EventStore.instance.pushEvent "#{self} at #{getCurrentCell.locationText} built #{room_to_construct}. Killing."
          kill
        end
      end
    end

    ant
  end
end

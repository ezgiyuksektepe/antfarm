require_relative 'BaseRoom'

class ForagerRoom < BaseRoom
  def initialize(hill)
    super(hill, Ant::TYPE_FORAGER)
  end

  def produceAnt
    ant = Ant.new(hill.colony, ant_type)
    class << ant
      def processTurn
        if getCurrentCell.food > 0
          hill = Meadow.instance.getAnthillForColony(colony)
          food_to_add = getCurrentCell.food

          # Type to gather more food using experience.
          # Modifier is experience / 5 or 1, if experience is less than 5
          food_to_add = food_to_add * [(self.experience / 5).round, 1].max
          EventStore.instance.pushEvent "#{self} found #{getCurrentCell.food} food on cell #{getCurrentCell.locationText}. Adding #{food_to_add} to its hill"
          self.experience += 1
          hill.addFood(food_to_add)
          getCurrentCell.consumeFood(getCurrentCell.food)
        end
      end
    end

    ant
  end
end
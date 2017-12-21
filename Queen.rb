require_relative 'Anthill'
require_relative 'AnthillBuilder'
require_relative 'Strategy'

class Queen
  attr_reader :colony

  def initialize(meadow, colony)
    @meadow = meadow
    @colony = colony
  end

  def release
    # Find a free cell
    cell = nil
    while true
      cell = @meadow.getRandomCell
      if cell.hill == nil
        break
      end
    end

    strategy = Strategy.new

    AnthillBuilder.new.forColony(colony).withStrategy(strategy).atCell(cell).build
  end
end

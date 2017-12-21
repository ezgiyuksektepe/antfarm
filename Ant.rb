require_relative 'Colors'
require_relative 'Meadow'

class Ant
  TYPE_WARRIOR = 1
  TYPE_FORAGER = 2
  TYPE_BUILDER = 3

  ALL_TYPES = [TYPE_BUILDER, TYPE_WARRIOR, TYPE_FORAGER]

  attr_reader :colony
  attr_reader :type
  attr_accessor :experience

  def initialize(colony, type)
    @colony = colony
    @type = type
    @experience = 0
    @current_cell = nil
  end

  def getMoveIntent
    # Builder ants don't move
    if @type == TYPE_BUILDER
      [0,0]
    else
      # This will technically allow ants to move diagonally as well (-1,-1) to (1,1)
      move = [0, 0]
      # This will set either 0th or the first element to -1,0, or 1
      move[rand(0..1)] = rand(-1..1)

      move
    end
  end

  # This is modified at the runtime, while creating the ant at their rooms
  def processTurn
    raise "Unmodified ant's processTurn was used"
  end

  def to_s
    str = ""
    if @type == TYPE_BUILDER
      str = "B"
    elsif @type == TYPE_FORAGER
      str = "F"
    elsif @type == TYPE_WARRIOR
      str = "W"
    end
    Colors.colorizeForColony(str, @colony)
  end

  def setCurrentCell(cell)
    @current_cell = cell
  end

  def getCurrentCell
    if @current_cell == nil
      Meadow.instance.findCellOfAnt(self)
    else
      @current_cell
    end
  end

  def kill
    EventStore.instance.pushEvent("#{self} died at #{getCurrentCell.locationText}")
    getCurrentCell.removeAnt(self)
  end

  def self.type_to_s(type)
    str = ""
    if type == TYPE_BUILDER
      str = "B"
    elsif type == TYPE_FORAGER
      str = "F"
    elsif type == TYPE_WARRIOR
      str = "W"
    end
    str
  end
end

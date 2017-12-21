require_relative 'Ant'
require_relative 'RoomFactory'
require_relative 'ForagerRoom'
require_relative 'WarriorRoom'

class Anthill
  attr_reader :cell
  attr_reader :colony
  attr_reader :strategy
  attr_reader :food
  attr_reader :rooms
  attr_accessor :destroyed

  def initialize(colony, strategy, cell)
    @colony = colony
    @strategy = strategy
    @cell = cell

    @food = 5
    @rooms = []
    @current_room_index = 0

    @destroyed = false

    # Add initial set of ants
    # First ant is always a builder
    # Use temporary rooms to build ants
    addAnt RoomFactory.build(self, Ant::TYPE_BUILDER).produceAnt

    # Second ant is always a forager
    addAnt RoomFactory.build(self, Ant::TYPE_FORAGER).produceAnt

    for i in (0...3)
      addAnt RoomFactory.build(self, Ant::ALL_TYPES.sample).produceAnt
    end
  end

  def destroy
    @destroyed = true
    @cell.hill = nil
  end

  def processTurn
    if @destroyed
      return
    end

    # Create ants if there's food and a room
    if @food > 0 && @rooms.length > 0 && Meadow.instance.getAntsForColony(@colony).length < Meadow.instance.max_ants_per_hill && consumeFood(1)
      room_to_use = @rooms[@current_room_index]
      @current_room_index = (@current_room_index + 1) % @rooms.length

      ant = room_to_use.produceAnt
      addAnt(ant)
    end
  end

  def addAnt(ant)
    @cell.getAnts.push(ant)
    EventStore.instance.pushEvent "#{ant} was born at #{@cell.locationText}"
  end

  def addFood(food)
    @food = @food + food
  end

  def consumeFood(food)
    @food = @food - food
  end

  def addRoom(type)
    new_room = RoomFactory.build(self, type)
    @rooms.push(new_room)
  end

  def to_s
    Colors.colorizeForColony("^", @colony)
  end
end

require_relative 'Ant'
require_relative 'BuilderRoom'
require_relative 'ForagerRoom'
require_relative 'WarriorRoom'

class RoomFactory
  def self.build(hill, type)
    if type == Ant::TYPE_BUILDER
      BuilderRoom.new(hill)
    elsif type == Ant::TYPE_FORAGER
      ForagerRoom.new(hill)
    elsif type == Ant::TYPE_WARRIOR
      WarriorRoom.new(hill)
    end
  end
end

require_relative 'Ant'

class BaseRoom
  attr_reader :ant_type
  attr_reader :hill

  def initialize(hill, type)
    @hill = hill
    @ant_type = type
  end

  def produceAnt
    # Ant.new(@hill.colony, @ant_type)
    raise "BaseRoom shouldn't be used"
  end

  def to_s
    Ant::type_to_s(@ant_type)
  end
end

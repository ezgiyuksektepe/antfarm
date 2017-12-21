require_relative 'Ant'

class Strategy
  STRATEGY1 = [Ant::TYPE_BUILDER, Ant::TYPE_FORAGER, Ant::TYPE_WARRIOR, Ant::TYPE_WARRIOR, Ant::TYPE_WARRIOR]
  STRATEGY2 = [Ant::TYPE_BUILDER, Ant::TYPE_FORAGER, Ant::TYPE_FORAGER, Ant::TYPE_WARRIOR, Ant::TYPE_WARRIOR]
  STRATEGY3 = [Ant::TYPE_BUILDER, Ant::TYPE_FORAGER, Ant::TYPE_FORAGER, Ant::TYPE_FORAGER, Ant::TYPE_WARRIOR]
  STRATEGY4 = [Ant::TYPE_FORAGER, Ant::TYPE_WARRIOR, Ant::TYPE_BUILDER]
  STRATEGY5 = [Ant::TYPE_FORAGER, Ant::TYPE_BUILDER, Ant::TYPE_WARRIOR]

  ALL_STRATEGIES = [STRATEGY1, STRATEGY2, STRATEGY3, STRATEGY4, STRATEGY5]

  def initialize
    @current_strategy = ALL_STRATEGIES.sample
    @current_index = 0
  end

  def hasNext
    @current_index < @current_strategy.length
  end

  def next
    result = @current_strategy[@current_index]
    @current_index += 1

    result
  end
end

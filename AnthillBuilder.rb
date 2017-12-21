class AnthillBuilder
  def initialize
    @colony = nil
    @strategy = nil
    @cell = nil
  end

  def forColony(colony)
    @colony = colony
    self
  end

  def withStrategy(strategy)
    @strategy = strategy
    self
  end

  def atCell(cell)
    @cell = cell
    self
  end

  def build
    if @cell.nil?
      raise "Cell wasn't set"
    end

    if @strategy.nil?
      raise "Strategy wasn't set"
    end

    if @colony.nil?
      raise "Colony wasn't set"
    end

    hill = Anthill.new(@colony, @strategy, @cell)
    @cell.hill = hill
  end
end
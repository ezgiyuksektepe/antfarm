require_relative 'Colors'

class Cell
  attr_reader :row
  attr_reader :col
  attr_reader :food
  attr_accessor :hill

  def initialize(row, col)
    @hill = nil
    @food = 0
    @ants = Array.new
    @row = row
    @col = col
  end

  def getFood
    @food
  end

  def getHill
    @hill
  end

  def getAnts
    @ants
  end

  def removeAnt(ant)
    @ants.delete(ant)
  end

  def addFood(a)
    @food = a + @food
  end

  def consumeFood(a)
    if @food > 0
      @food = @food - 1
      true
    else
      false
    end
  end

  def setHill(hill)
    @hill = hill
  end

  def to_s
    result = ""
    #result += "Cell: #{@row}, #{@col}. "
    if @hill != nil
      result += @hill.to_s
    end

    if @food != 0
      result += "f"
    end

    result += getAnts.map {|a| a.to_s}.sort.uniq.join("")
    result.split.sort.uniq.join("")
  end

  def locationText
    "#{@row},#{@col}"
  end
end

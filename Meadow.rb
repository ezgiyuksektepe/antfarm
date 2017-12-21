require 'colorize'
require 'set'
require 'singleton'
require_relative 'Cell'
require_relative 'EventStore'
require_relative 'Queen'

class Meadow
  include Singleton

  attr_reader :num_cols
  attr_reader :num_rows
  attr_reader :num_queens
  attr_reader :max_ants_per_hill
  attr_reader :grid

  def initialize
    # Meadow configuration
    @num_rows = 15
    @num_cols = 15
    @num_queens = 4
    @max_ants_per_hill = @num_rows

    @grid = Array.new(@num_rows) {|row| Array.new(@num_cols) {|col| Cell.new(row, col)}}
    @queens = Array.new(@num_queens) {|index| Queen.new(self, index)}

    # Release all queens so they can build hills
    @queens.each {|q| q.release}
  end

  def getCell(row, col)
    if row < 0 || col < 0 || row > @num_rows - 1 || col > @num_cols - 1
      raise "Invalid position #{row},#{col}"
    end
    @grid[row][col]
  end

  def getRandomCell
    row = rand(0...@num_rows)
    col = rand(0...@num_cols)
    @grid[row][col]
  end

  def placeFood
    cell = getRandomCell
    cell.addFood(1)
  end

  def processTurn
    processAnts
    processHills
  end

  def processHills
    for row in (0...@num_rows)
      for col in (0...@num_cols)
        cell = @grid[row][col]

        # If there's a hill, let it take the its turn
        if cell.hill != nil
          cell.hill.processTurn
        end
      end
    end
  end

  def processAnts
    ants_took_turns = Set.new

    for row in (0...@num_rows)
      for col in (0...@num_cols)
        cell = @grid[row][col]
        ants_in_cell = cell.getAnts

        for ant in ants_in_cell
          # If ant has taken turns skip it
          next if ants_took_turns.include?(ant)

          # Move the ant
          move_intent = ant.getMoveIntent
          new_row = row + move_intent[0]
          new_col = col + move_intent[1]

          # Check grid limits
          if new_row < 0 || new_row > @num_rows - 1
            new_row = row
          end

          if new_col < 0 || new_col > @num_cols - 1
            new_col = col
          end

          new_cell = @grid[new_row][new_col]
          # Remove from the old cell and add it to the new one
          ants_in_cell.delete(ant)
          new_cell.getAnts.push(ant)

          # Update the cell variable in ant
          ant.setCurrentCell(new_cell)

          # Let ant take its turn
          ant.processTurn
          ants_took_turns.add(ant)
        end
      end
    end
  end

  def checkEndStates
    num_active_colonies = 0
    last_active_colony = nil
    for i in (0..@num_queens)
      hill = getAnthillForColony(i)
      if hill != nil
        num_active_colonies += 1
        last_active_colony = i
        ants = getAntsForColony(i)
        if ants.find { |a| a.type == Ant::TYPE_FORAGER } == nil
          EventStore.instance.pushEvent "Colony #{i} doesn't have any foragers left."
          destroyColony(i)
        end
      end
    end

    if num_active_colonies == 1
      EventStore.instance.pushEvent "Winning colony is #{Colors.colorizeForColony(last_active_colony, last_active_colony)}!!"
      Game.instance.keep_running = false
    elsif num_active_colonies < 1
      EventStore.instance.pushEvent "All colonies were destroyed!".on_red
      Game.instance.keep_running = false
    end
  end

  def destroyColony(colony)
    EventStore.instance.pushEvent "Destroying colony #{Colors.colorizeForColony(colony, colony)}"
    hill = getAnthillForColony(colony)
    ants = getAntsForColony(colony)
    hill.destroy
    ants.each { |a| a.kill }
  end

  def getAntsForColony(colony)
    results = []
    for row in (0...@num_rows)
      for col in (0...@num_cols)
        cell = @grid[row][col]
        ants_in_cell = cell.getAnts

        ants = ants_in_cell.select {|ant| ant.colony == colony }
        if ants.length != 0
          results += ants
        end
      end
    end

    results
  end

  def getAnthillForColony(colony)
    for row in (0...@num_rows)
      for col in (0...@num_cols)
        cell = @grid[row][col]
        if cell.hill != nil && cell.hill.colony == colony
          return cell.hill
        end
      end
    end

    return nil
  end

  def findCellOfAnt(ant)
    for row in (0...@num_rows)
      for col in (0...@num_cols)
        cell = @grid[row][col]
        if cell.getAnts.include?(ant)
          return cell
        end
      end
    end
    return nil
  end
end

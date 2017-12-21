require 'io/console'
require 'singleton'
require_relative 'Meadow'

class Game
  include Singleton

  attr_accessor :keep_running

  def initialize
    @meadow = Meadow.instance
    @keep_running = true
  end

  def run
    while @keep_running
      #every turn, place food
      @meadow.placeFood
      @meadow.processTurn
      @meadow.checkEndStates
      displayGame

      sleep(0.05)
      # gets
    end
  end

  def clearScreen
    # Found at https://stackoverflow.com/questions/3170553/how-can-i-clear-the-terminal-in-ruby
    Gem.win_platform? ? (system "cls") : (system "clear")
  end

  def drawGameGrid
    result = ""
    window_size = IO.console.winsize
    win_columns = window_size[1]

    col_size = ((win_columns - 1) / Meadow.instance.num_cols) - 1
    total_size = col_size * Meadow.instance.num_cols + Meadow.instance.num_cols + 1

    # Begin drawing the grid
    result += "-" * total_size + "\n"
    for i in (0...Meadow.instance.num_rows)
      # Left side of the screen starts with |
      result += "|"
      for j in (0...Meadow.instance.num_cols)
        grid_text = Meadow.instance.grid[i][j].to_s

        # I didn't use .center because colorized strings have more characters in them
        # This block calculates padding and centers the text
        uncolorized_text = grid_text.uncolorize
        left_padding = (col_size - uncolorized_text.length) / 2
        right_padding = (col_size - uncolorized_text.length - left_padding)

        result += " " * [left_padding, 0].max
        result += grid_text
        result += " " * [right_padding, 0].max

        # Every cell is followed by |
        result += "|"
      end
      result += "\n"
      # Draw a line
      result += "-" * total_size + "\n"
    end

    result
  end

  def drawColonyStats
    result = ""

    window_size = IO.console.winsize
    win_columns = window_size[1]

    # Colony stats
    for i in (0...Meadow.instance.num_queens)
      colony_hill = Meadow.instance.getAnthillForColony(i)
      ants = Meadow.instance.getAntsForColony(i).map{|a| a.to_s}.sort.join(",")

      result += "Colony ##{i}".center(win_columns, "=") + "\n"
      if colony_hill == nil || colony_hill.destroyed
        result += "DESTROYED".on_red + "\n"
      else
        result += "Food: #{colony_hill.food}" + "\n"
        result += "Ants: #{ants}" + "\n"
        result += "Rooms: #{colony_hill.rooms.join(",")}" + "\n"
      end
    end

    result
  end

  def drawEvents
    result = ""

    window_size = IO.console.winsize
    win_columns = window_size[1]

    result += "Events".center(win_columns, "=") + "\n"
    EventStore.instance.getEvents.each{|e| result += e + "\n"}
    EventStore.instance.clearEvents

    result
  end

  def displayGame
    grid = drawGameGrid
    colony_stats = drawColonyStats
    events = drawEvents

    clearScreen
    puts grid
    puts colony_stats
    puts events
  end
end

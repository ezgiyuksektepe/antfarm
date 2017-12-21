require 'colorize'

class Colors
  def self.colorizeForColony(s, colony)
    colors = String.colors
    s.to_s.colorize(colors[(colony * 2 + 2)%colors.length])
  end
end

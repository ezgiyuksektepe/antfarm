require_relative 'BaseRoom'

class WarriorRoom < BaseRoom
  def initialize(hill)
    super(hill, Ant::TYPE_WARRIOR)
  end

  def produceAnt
    ant = Ant.new(@hill.colony, @ant_type)
    class << ant
      def processTurn
        hostile_ant = getCurrentCell.getAnts.find {|a| a.colony != self.colony}
        if hostile_ant != nil
          if hostile_ant.type == TYPE_FORAGER
            EventStore.instance.pushEvent "#{self} is attacking #{hostile_ant} at #{getCurrentCell.locationText}."
            if rand(0..1) == 1
              EventStore.instance.pushEvent "#{self} killed #{hostile_ant} at #{getCurrentCell.locationText}."
              hostile_ant.kill
              self.experience += 2
            else
              EventStore.instance.pushEvent "#{self} couldn't kill #{hostile_ant} at #{getCurrentCell.locationText}."
              self.experience += 1
            end
          elsif hostile_ant.type == TYPE_WARRIOR
            r = rand(0...1000)
            r += self.experience
            r -= hostile_ant.experience

            if r > 500
              EventStore.instance.pushEvent "#{self} killed #{hostile_ant} at #{getCurrentCell.locationText}."
              hostile_ant.kill
              self.experience += 2
            else
              EventStore.instance.pushEvent "#{self} died while attacking #{hostile_ant} at #{getCurrentCell.locationText}."
              hostile_ant.experience += 2
              self.kill
            end
          end
        end

        if getCurrentCell.hill != nil && getCurrentCell.hill.colony != self.colony
          hostile_hill = getCurrentCell.hill
          EventStore.instance.pushEvent "#{self} is attacking #{hostile_hill}"
          # 20% chance of destroying the hill
          if rand(1..5) == 5
            EventStore.instance.pushEvent "#{self} destroyed #{hostile_hill}"
            Meadow.instance.destroyColony(hostile_hill.colony)
            self.experience += 5
          else
            EventStore.instance.pushEvent "#{self} couldn't destroy #{hostile_hill}"
          end
        end
      end
    end

    ant
  end
end
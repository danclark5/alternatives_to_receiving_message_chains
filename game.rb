class GrumpyGameFairy < StandardError
  def initialize(msg="Outlook is cloudy, try again later")
    super
  end
end

class GameFairy
  def proclamation
    if mystic_visions == 'The game is in a stalemate!'
      false
    elsif mystic_visions == 'The game is won!'
      true
    else
      raise GrumpyGameFairy
    end
  end

  private

  def mystic_visions
    "Leave me alone!"
  end
end

class GameFairyGateway
  def self.get_fairy
    game_fairy = GameFairy.new()
  end
end

class Game
  def done?
    return GameFairyGateway.get_fairy.proclamation
  end
end

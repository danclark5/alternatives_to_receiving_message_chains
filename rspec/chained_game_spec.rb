require_relative '../game'

describe Game do
  subject(:game) { Game.new() }
  describe '#done' do

    context 'the game fairy says there is a tie' do
      it 'returns false' do
        allow(GameFairyGateway).to receive_message_chain(:get_fairy, :proclamation) { false }
        expect(game.done?).to be false 
      end
    end

    context 'the game fairy says the player_1 is the winner' do
      it 'returns true' do
        allow(GameFairyGateway).to receive_message_chain(:get_fairy, :proclamation) { true }
        expect(game.done?).to be true 
      end
    end
  end
end

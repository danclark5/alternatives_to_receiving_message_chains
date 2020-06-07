require_relative '../game'

describe Game do
  subject(:game) { Game.new() }
  describe '#done' do
    let(:game_fairy) { double }

    before do 
      allow(game_fairy).to receive(:proclamation).and_return( proclamation_output )
      allow(GameFairyGateway).to receive(:get_fairy).and_return(game_fairy)
    end

    context 'the game fairy says there is a tie' do
      let(:proclamation_output) { false }
      it 'returns false' do
        expect(game.done?).to be false 
      end
    end

    context 'the game fairy says the player_1 is the winner' do
      let(:proclamation_output) { true }
      it 'returns true' do
        expect(game.done?).to be true 
      end
    end
  end
end

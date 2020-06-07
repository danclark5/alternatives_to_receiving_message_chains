The wording on the [Message Chains
page](https://relishapp.com/rspec/rspec-mocks/v/3-9/docs/working-with-legacy-code/message-chains) is very careful to
warn that `receive_message_chain` makes it painlessly easy to break [the Law of
Demeter](https://en.wikipedia.org/wiki/Law_of_Demeter). They even go on to explain that double and instance double offer
a better way of testing code with these chained method patterns.

# Using `double` and `receive` in place of `receive_message_chain`

The tests in question look like this

```ruby
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
```

and they are for the following code

```ruby
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
```

Again, we want to avoid using the `receive_message_chain` helper method. It their place we want to use a double for our
`GameFairy`. To that end we'll add `game_fairy` as helper methods via let.

```ruby
  describe '#done' do
    let(:game_fairy) { double }
```

This gives us a double to use in place of the real game fairy, but we still need to stub out the methods being used by
the `Game` class. We'll do with with `allow` and `receive`. We'll put those stubs into a before block in the root
decribe so that both contexts can use it, and we'll add another helper method to dictate what value should be returned
by `proclamation`. From there we fim

```ruby
    before do
      allow(game_fairy).to receive(:proclamation).and_return( proclamation_output )
      allow(GameFairyGateway).to receive(:get_fairy).and_return(game_fairy)
    end
```

Then we change our test like so.

```ruby
    context 'the game fairy says there is a tie' do
      let(:proclamation_output) { false }
      it 'returns false' do
        expect(game.done?).to be false
      end
    end
```

Note that we've removed the `receive_message_chain` stubbing, and we've added the `proclamation_output` helper
declaration.

# Conclusion

This way might be a little less natural, but it's the recommended path made by the rspec documentation. You can find
[this code on my repo](https://github.com/danclark5/alternatives_to_receiving_message_chains).

Thanks for reading!

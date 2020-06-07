The wording on the [Message Chains
page](https://relishapp.com/rspec/rspec-mocks/v/3-9/docs/working-with-legacy-code/message-chains) is very careful to
warn that `receive_message_chain` makes it painlessly easy to break [the Law of
Demeter](https://en.wikipedia.org/wiki/Law_of_Demeter). They even go on to explain that double and instance double offer
a better way of testing code with these chained method patterns.

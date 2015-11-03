# Hamstar

`Hamstar.update_having` is a `module_function` that works just like [Hamster update_in()](https://github.com/hamstergem/hamster#transformations) but with three additional ways to select container elements:

1. the associative selector denoted by an array containing a key and a value e.g. `[:name,'Chris']`
2. the Kleene star operator denoted by '*'
3. generalized `Proc`-based matching e.g. you can supply a lambda directly in the path specification

## Installation

Add this line to your application's Gemfile:

    gem 'hamstar'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hamstar

## Usage

With plain old `update_in()` you can:

```ruby
require 'hamster'
x = Hamster.from([{name:'Chris', hobbies:['clarinet']},{name:'Pat',hobbies:['bird watching','rugby']}])
x.update_in(1,:name){|name| 'Patsy'}
=> Hamster::Vector[Hamster::Hash[:hobbies => Hamster::Vector["clarinet"], :name => "Chris"], Hamster::Hash[:hobbies => Hamster::Vector["bird watching", "rugby"], :name => "Patsy"]]
```

You can do the exact same thing with Hamstar's `update_having()`:

```ruby
require 'hamstar'
Hamstar.update_having( x, 1,:name){|name| 'Patsy'}
=> (same result as before)
```

And you can go further, and replace the vector offset `1` with the Kleene star `'*'` to operate on all elements of the vector:

```ruby
Hamstar.update_having( x, '*',:name){|name| name + 'sy'}
=> Hamster::Vector[Hamster::Hash[:name => "Chrissy", :hobbies => Hamster::Vector["clarinet"]], Hamster::Hash[:name => "Patsy", :hobbies => Hamster::Vector["bird watching", "rugby"]]]
```

And what if you wanted to efficiently replace every 'Pat' with 'Patsy', without having to add conditional code to your block? Hamstar let's you use a key/value pair as part of your path specification:

```ruby
Hamstar.update_having( x, [:name,'Pat'],:name){|name| 'Patsy'}
=> Hamster::Vector[Hamster::Hash[:name => "Chris", :hobbies => Hamster::Vector["clarinet"]], Hamster::Hash[:name => "Patsy", :hobbies => Hamster::Vector["bird watching", "rugby"]]]
```

Finally, you can use a `Proc` as a matcher. Here's an example that supplies a lambda inline:

```ruby
Hamstar.update_having( x, ->(k,v){v[:name] == 'Pat'},:name){|name| 'Patsy'}
 => Hamster::Vector[Hamster::Hash[:name => "Chris", :hobbies => Hamster::Vector["clarinet"]], Hamster::Hash[:name => "Patsy", :hobbies => Hamster::Vector["bird watching", "rugby"]]]
```

See [`hamstar_spec.rb`](file://spec/hamstar_spec.rb) for more examples.


## Contributing

1. Fork it ( http://github.com/Bill/hamstar/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

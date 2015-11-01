# Hamstar



## Installation

Add this line to your application's Gemfile:

    gem 'hamstar'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hamstar

## Usage

`Hamstar.update_having` is a `module_function` that works just like [Hamster update_in()](https://github.com/hamstergem/hamster#transformations) but with two additional ways to select container elements:

1. the associative selector denoted by an array containing a key and a value e.g. `[:name,'Chris']`
2. the Kleen star operator denoted by '*'

With plain old `update_in()` you can:

```ruby
require 'hamster'
x = [{name:'Chris', hobbies:['clarinet']},{name:'Pat',hobbies:['bird watching','rugby']}]
Hamster.from(x).update_in(1,:name){|name| 'Patsy'}
=> Hamster::Vector[Hamster::Hash[:hobbies => Hamster::Vector["clarinet"], :name => "Chris"], Hamster::Hash[:hobbies => Hamster::Vector["bird watching", "rugby"], :name => "Patsy"]]
```

With Hamstar you can write code that is a little more flexibly:

```ruby
require 'hamstar'
Hamstar.update_having( Hamster.from(x), 1,:name){|name| 'Patsy'}
=> (same result as before)
```

And you can go further, and replace the vector offset `1` with the Kleene star `'*'` to operate on all elements of the vector:

```ruby
Hamstar.update_having( Hamster.from(x), '*',:name){|name| 'Patsy'}
=> (same result as before)
```

See [`hamstar_spec.rb`](file://spec/hamstar_spec.rb) for more examples.


## Contributing

1. Fork it ( http://github.com/Bill/hamstar/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

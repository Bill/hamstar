require 'hamstar/version'
require 'hamstar/initializers'
require 'hamster'

module Hamstar

  KLEENE_STAR = '*'

  module_function

  def update_having(c, *match_path, &block)
    if match_path.empty?
      raise ArgumentError, "must have at least one matcher in path"
    end
    matcher = match_path[0]
    case matcher
    when KLEENE_STAR; match ->(k,v){true}, c, *match_path, &block
    when Array, Hamster::Vector; match ->(k,v){key,value=matcher; v[key] == value}, c, *match_path, &block
    when Proc; match matcher, c, *match_path, &block
    else
      if match_path.size == 1
        new_value = block.call c.fetch(matcher,nil)
      else
        value = c.fetch matcher, Hamster::EmptyHash
        new_value = update_having value, *match_path[1..-1], &block
      end
      c.put matcher, new_value
    end
  end

  def match(matcher, c, *match_path, &block)
    mp_rest = Hamster.from(match_path)[1..-1] # drop first expr
    c.each_pair do |key,value|
      if matcher.call key, value
        mp = mp_rest.unshift key # put key where expr was
        c = update_having c, *mp, &block
      end
    end
    c
  end

end

require 'hamstar/version'
require 'hamstar/initializers'
require 'hamster'

module Hamstar

  KLEENE_STAR = '*'
  MATCH_KLEENE_STAR = ->(k,v,expr){true}
  MATCH_ASSOCIATION = ->(k,v,expr){key,value=expr; v[key] == value}

  module_function

  def update_having(c, *match_path, &block)
    if match_path.empty?
      raise ArgumentError, "must have at least one matcher in path"
    end
    matcher = match_path[0]
    case matcher
    when KLEENE_STAR; match MATCH_KLEENE_STAR, c, *match_path, &block
    when Array, Hamster::Vector; match MATCH_ASSOCIATION, c, *match_path, &block
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
    expr = match_path[0]
    mp_rest = Hamster.from(match_path)[1..-1] # drop expr
    c.each_pair do |key,value|
      if matcher.call key, value, expr
        mp = mp_rest.unshift key # put key where assoc was
        c = update_having c, *mp, &block
      end
    end
    c
  end

end

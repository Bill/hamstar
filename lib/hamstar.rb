require 'hamstar/version'
require 'hamstar/initializers'
require 'hamster'

module Hamstar

  KLEENE_STAR = '*'
  MATCH_KLEENE_STAR = ->(k,v,expr){true}
  MATCH_ASSOCIATION = ->(k,v,expr){key,value=expr; v[key] == value}

  module_function

  def update_having(c, *key_path, &block)
    if key_path.empty?
      raise ArgumentError, "must have at least one key in path"
    end
    key = key_path[0]
    case key
    when KLEENE_STAR; match MATCH_KLEENE_STAR, c, *key_path, &block
    when Array, Hamster::Vector; match MATCH_ASSOCIATION, c, *key_path, &block
    else
      if key_path.size == 1
        new_value = block.call c.fetch(key,nil)
      else
        value = c.fetch key, Hamster::EmptyHash
        new_value = update_having value, *key_path[1..-1], &block
      end
      c.put key, new_value
    end
  end

  def match(matcher, c, *key_path, &block)
    expr = key_path[0]
    kp_rest = Hamster.from(key_path)[1..-1] # drop expr
    c.each_pair do |key,value|
      if matcher.call key, value, expr
        kp = kp_rest.unshift key # put key where assoc was
        c = update_having c, *kp, &block
      end
    end
    c
  end

end

require 'hamstar/version'
require 'hamstar/initializers'
require 'hamster'

module Hamstar

  KLEENE_STAR = :'*'

  module_function

  def update_having(c, *key_path, &block)
    if key_path.empty?
      raise ArgumentError, "must have at least one key in path"
    end
    key = key_path[0]
    case key
    when KLEENE_STAR; kleene_star c, *key_path, &block
    when Array, Hamster::Vector; association c, *key_path, &block
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

  def kleene_star(c, *key_path, &block)
    kp_rest = Hamster.from(key_path)[1..-1] # drop kleene star
    c.keys.each do |key|
      kp = kp_rest.unshift key # put key where kleene star was
      c = update_having c, *kp, &block
    end
    c
  end

  def association(c, *key_path, &block)
    key,value = key_path[0]
    kp_rest = Hamster.from(key_path)[1..-1] # drop assoc
    c.each_pair do |k,v|
      if v[key] == value
        kp = kp_rest.unshift k # put key where assoc was
        c = update_having c, *kp, &block
      end
    end
    c
  end

end

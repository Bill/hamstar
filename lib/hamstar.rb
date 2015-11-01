require 'hamstar/version'
require 'hamstar/ext'
require 'hamster'


module Hamstar

  KLEENE_STAR = :'*'

  module_function

  def update_having(c, *key_path, &block)
    if key_path.empty?
      raise ArgumentError, "must have at least one key in path"
    end
    if key_path[0] == KLEENE_STAR
      kleene_star c, *key_path, &block
    else
      c.update_in *key_path, &block
    end
  end

  def kleene_star(c, *key_path, &block)
    kp_nostar = Hamster.from(key_path)[1..-1] # drop kleene star
    c.keys.each do |key|
      kp = kp_nostar.unshift key # put key where kleene star was
      c = update_having c, *kp, &block
    end
    c
  end

end

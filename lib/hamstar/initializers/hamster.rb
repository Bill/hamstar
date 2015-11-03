require 'hamster'

module Hamster
  class Vector
    def each_pair
      each_with_index do |v,i|
        yield i,v
      end
    end
  end
end

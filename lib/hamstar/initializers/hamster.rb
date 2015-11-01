require 'hamster'

module Hamster
  class Vector
    # Vectors act a lot like associations. Why not give 'em a keys method?
    def keys
      (0..(size-1))
    end
    def values
      self
    end
    def each_pair
      each_with_index do |v,i|
        yield i,v
      end
    end
  end
end

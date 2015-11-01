require 'spec_helper'

require 'hamstar'
require 'hamster'

RSpec.describe Hamstar do
  cases = [
    [{a:1},        [:b],      ->(v){2},   {a:1,b: 2},    'adds values for keys not already in Hash'],
    [[1],          [1],       ->(v){2},   [1,2],         'adds values for offsets not already in Vector'],
    [{a:1,b:[1,2]},[:b,1],    ->(v){v+1}, {a:1,b:[1,3]}, 'traverses array and hash by key'],
    [{a:1,b:2},    [:'*'],    ->(v){v+1}, {a:2,b:3},     'star works on Hash'],
    [[1,2],        [:'*'],    ->(v){v+1}, [2,3],         'star works on Vector'],
    [{a:[1],b:[2]},[:'*', 0], ->(v){v+1}, {a:[2],b:[3]}, 'update works below star on Hash'],
    [[[1],[2]],    [:'*', 0], ->(v){v+1}, [[2],[3]],     'update works below star on Vector']
  ]
  describe '#update_having' do

    cases.each do |c|
      it c[4] do
        x = Hamster.from( c[0] )
        y = Hamstar.update_having(x, *c[1], &c[2])
        expect(Hamster.to_ruby y).to eq(c[3])
      end
    end

    # it 'traverses hash by key/value pair' do
    #   x = Hamster.from( [{name: 'Chris', home: 'Seattle'},{name: 'Pat', home: 'Portland'}] )
    #   y = Hamstar.update_having( )
    # end
  end
end

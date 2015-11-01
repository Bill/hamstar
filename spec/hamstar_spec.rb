require 'spec_helper'

require 'hamstar'
require 'hamster'

RSpec.describe Hamstar do
  examples_update_in_regression = [
    [ {a:1},        [:b],      ->(v){2},   {a:1,b: 2},    'adds values for keys not already in Hash'],
    [ [1],          [1],       ->(v){2},   [1,2],         'adds values for offsets not already in Vector'],
    [ {a:1,b:[1,2]},[:b,1],    ->(v){v+1}, {a:1,b:[1,3]}, 'traverses Hash of Vector by key'],
    [ [1,{b:2}],    [1,:b],    ->(v){v+1}, [1,{b:3}],     'traverses Vector of Hash by key'],
  ]
  examples_kleene_star = [
    [ {a:1,b:2},    [:'*'],     ->(v){v+1}, {a:2,b:3},     'top level Hash'],
    [ [1,2],        [:'*'],     ->(v){v+1}, [2,3],         'top level Vector'],
    [ {a:[1],b:[2]},[:'*', 0],  ->(v){v+1}, {a:[2],b:[3]}, 'Vector underneath Hash'],
    [ [{a:1},{a:2}],[:'*', :a], ->(v){v+1}, [{a:2},{a:3}], 'Hash underneath Vector']
  ]

  def self.write_examples(examples)
    examples.each do |e|
      it e[4] do
        x = Hamster.from( e[0] )
        y = Hamstar.update_having(x, *e[1], &e[2])
        expect(Hamster.to_ruby y).to eq(e[3])
      end
    end
  end

  describe 'Hamster update_in functionality' do
    write_examples examples_update_in_regression
  end
  describe 'New kleene star functionality' do
    write_examples examples_kleene_star
  end

  # it 'traverses hash by key/value pair' do
  #   x = Hamster.from( [{name: 'Chris', home: 'Seattle'},{name: 'Pat', home: 'Portland'}] )
  #   y = Hamstar.update_having( )
  # end


end

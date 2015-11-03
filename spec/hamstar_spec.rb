require 'spec_helper'

require 'hamstar'
require 'hamster'

RSpec.describe Hamstar do
  examples_update_in_regression = [
    [ {a:1},        [:b],      ->(v){2},   {a:1,b: 2},    'adds values for keys not already in Hash'],
    [ [1],          [1],       ->(v){2},   [1,2],         'adds values for offsets not already in Vector'],
    [ {a:1,b:[1,2]},[:b,1],    ->(v){v+1}, {a:1,b:[1,3]}, 'traverses Hash of Vector'],
    [ [1,{b:2}],    [1,:b],    ->(v){v+1}, [1,{b:3}],     'traverses Vector of Hash'],
  ]
  examples_kleene_star = [
    [ {a:1,b:2},    ['*'],     ->(v){v+1}, {a:2,b:3},     'top level Hash'],
    [ [1,2],        ['*'],     ->(v){v+1}, [2,3],         'top level Vector'],
    [ {a:[1],b:[2]},[:b,'*'],  ->(v){v+1}, {a:[1],b:[3]}, 'Hash containing Vector'],
    [ [{a:1},{a:2}],[0,'*'],   ->(v){v+1}, [{a:2},{a:2}], 'Vector containing Hash'],
    [ {a:[1],b:[2]},['*',0],   ->(v){v+1}, {a:[2],b:[3]}, 'Vector inside Hash'],
    [ [{a:1},{a:2}],['*',:a],  ->(v){v+1}, [{a:2},{a:3}], 'Hash inside Vector']
  ]

  examples_associative = [
    [ [{name:'Chris'},{name:'Pat'}],  [[:name,'Pat'],:name],->(name){name+'sy'}, [{name:'Chris'},{name:'Patsy'}],  'match a Hash'],
    [ [[:name,'Chris'],[:name,'Pat']],[[1,'Pat'],1],        ->(name){name+'sy'}, [[:name,'Chris'],[:name,'Patsy']],'match a Vector']
  ]

  examples_function_match = [
    [ [{a:1},{b:1},{b:2}], ['*',->(k,v){k==:b && v==2}], ->(v){5}, [{a:1},{b:1},{b:5}],'match a Hash'],
    [ [[1,2],[3,4]],       ['*',->(k,v){k==0&&v==3}],->(v){7}, [[1,2],[7,4]],          'match a Vector']
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

  describe 'Inherited Hamster update_in functionality' do
    write_examples examples_update_in_regression
  end
  describe 'New kleene star' do
    write_examples examples_kleene_star
  end
  describe 'New association matching' do
    write_examples examples_associative
  end
  describe 'New functional matching' do
    write_examples examples_function_match
  end

end

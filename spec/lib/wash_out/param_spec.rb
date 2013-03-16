#encoding:utf-8

require 'spec_helper'

describe WashOut::Param do

  context "custom types" do
    class Abraka1 < WashOut::Type
      map(
        :test => :string
      )
    end
    class Abraka2 < WashOut::Type
      type_name 'test'
      map :foo => Abraka1
    end

    it "loads custom_types" do
      map = WashOut::Param.parse_def Abraka2

      map.should be_a_kind_of(Array)
      map[0].name.should == 'value'
      map[0].map[0].name.should == 'foo'
      map[0].map[0].map[0].name.should == 'test'
    end

    it "respects camelization setting" do
      WashOut::Engine.camelize_wsdl = true

      map = WashOut::Param.parse_def Abraka2

      map.should be_a_kind_of(Array)
      map[0].name.should == 'Value'
      map[0].map[0].name.should == 'Foo'
      map[0].map[0].map[0].name.should == 'Test'
    end
  end

  context "arrays" do

    it "should load arrays" do
      map = WashOut::Param.parse_def( {my_array: [:integer] } )
      map[0].load( {my_array: [1, 2, 3]}, :my_array).should == [1, 2, 3]
    end

    it "should load empty arrays" do
      map = WashOut::Param.parse_def( {my_array: [:integer] } )
      map[0].load( {my_array: []}, :my_array).should == []
#      map[0].load( {}, :my_array).should == []
#      map[0].load( nil, :my_array).should == []
    end

    it "should accept nested arrays" do
      map = WashOut::Param.parse_def( {:nested => {my_array: [:integer] }} )
      map[0].load( {nested: {my_array: [1, 2, 3]}}, :nested).should == {"my_array" => [1, 2, 3]}
    end

    it "should accept nested empty arrays" do
      map = WashOut::Param.parse_def( {:nested => {my_array: [:integer] }} )
      map[0].load( {nested: nil}, :nested).should == {"my_array" => []}
    end

  end

end

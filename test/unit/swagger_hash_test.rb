require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class SwaggerHashTest < Test::Unit::TestCase

  def setup
    $_swaggerhash = Hash.new
  end 

  def test_basics
    h = SwaggerHash.new
    
    h.o = 1
    assert_equal h, {:o => 1}
    
    h.u.u.u = {:y => "1"}
    assert_equal h, {:o => 1, :u => {:u => {:u => {:y => "1"}}}}
    
    h.x
    assert_equal h, {:o => 1, :u => {:u => {:u => {:y => "1"}}}, :x => {}}
    
    h.x = []
    assert_equal h, {:o => 1, :u => {:u => {:u => {:y => "1"}}}, :x => []}
    
  end
  
  def test_basics_add
    
    h = SwaggerHash.new
    
    v = h.x.y.z.add
    assert_equal v, {}
    assert_equal h, {:x => {:y => {:z => {:_array => [{}]}}}}
    
    v.a = 10
    assert_equal h, {:x => {:y => {:z => {:_array =>[{:a => 10}]}}}}
    
    v.b.b = "5"
    assert_equal h, {:x => {:y => {:z => {:_array =>[{:a => 10, :b => {:b => "5"}}]}}}}
    
    v = h.x.y.z.add
    assert_equal h, {:x => {:y => {:z => {:_array =>[{:a => 10, :b => {:b => "5"}},{}]}}}}
    
    v.c.c = "3"
    assert_equal h, {:x => {:y => {:z => {:_array =>[{:a => 10, :b => {:b => "5"}}, {:c => {:c => "3"}}]}}}}
    
  end
  
  def test_basics_add_params
    
    h = SwaggerHash.new
    
    h.z.add :a => 1
    h.z.add :a => 1
    
    assert_equal h.to_hash, {:z => [{:a => 1}, {:a => 1}]}
  
    h = SwaggerHash.new
    
    h.z.add :a => 1, :b => 2, :c => 3
    h.z.add :a => 1, :b => 2, :c => 3
    
    assert_equal h.to_hash, {:z => [{:a => 1, :b => 2, :c => 3}, {:a => 1, :b => 2, :c => 3}]}
    
    h = SwaggerHash.new

    h.z.add :a => 1, :b => 2, :c => 3
    h.z.add :a => 1, :b => 2, :c => 3
    i = h.z.add 
    i.bs = "k"

    assert_equal h.to_hash, {:z => [{:a => 1, :b => 2, :c => 3}, {:a => 1, :b => 2, :c => 3}, {:bs => "k"}]}
    
  end
  
  def test_to_hash
        
    h = SwaggerHash.new
    assert_equal h.to_hash, {}
        
    h = SwaggerHash.new
    a = h.x.y.add 
    a.a1 = "1"
    a.a2 = "2"
    
    a = h.x.y.add 
    a.a1 = "1"
    
    a = h.y.add
    
    a.set :bs => "k", :bs2 => "k2"
    
    a.bs3 = "k3"
    
    assert_equal h.to_hash, {:x => {:y => [{:a1 => "1", :a2 => "2"}, {:a1 => "1"}]}, :y => [{:bs => "k", :bs2 => "k2", :bs3 => "k3"}]}
     
  end
  
  
  def test_load_same_api_space
    
    a = SwaggerHash::namespace("namespace1")
    a.bla = 10
    a.foo = "100"
    
    a = SwaggerHash::namespace("namespace2")
    assert_equal a.to_hash, {}
    
    a = SwaggerHash::namespace("namespace1")
    assert_equal a.to_hash, {:bla => 10, :foo => "100"}

    a.bar.add :a => 1, :b => 2
    assert_equal a.to_hash, {:bla => 10, :foo => "100", :bar => [{:a => 1, :b => 2}]}
    
    a = SwaggerHash::namespace("namespace2")
    assert_equal a.to_hash, {}
    
    a = SwaggerHash::namespace("namespace1")
    assert_equal a.to_hash, {:bla => 10, :foo => "100", :bar => [{:a => 1, :b => 2}]}
    
  end
  
  def test_save

    a = SwaggerHash::namespace("namespace1")
    a.bla = 10
    a.foo = "100"

    b = SwaggerHash::namespace("namespace2")

    assert_equal $_swaggerhash["namespace1"].to_hash, {:bla => 10, :foo => "100"}
    assert_equal $_swaggerhash["namespace2"].to_hash, {}

  end
  

  def test_compare
    
    reader = SwaggerReader.new
    
    assert_equal [], diff([],[])
    assert_equal [], diff({},{})
    assert_equal [], diff("10","10")    
    assert_not_equal [], diff("10","11")
      
    assert_equal [], diff({:a=>1,:b=>{:a=>1}},{:b=>{:a=>1},:a=>1})
    assert_not_equal [], diff({:a=>1,:b=>{:a=>1}},{:b=>{:a=>1},:a=>"1"})
    assert_not_equal [], diff({:a=>1,:b=>{:a=>1}},{:b=>{:a=>2},:a=>1})

    assert_equal [], diff({:a=>1,:b=>{:a=>1,:c=>[ 11, 10, 9] }},{:b=>{:c=>[9, 10, 11],:a=>1},:a=>1})
    
    a = {:a=>1, :b=>{:a=>1, :c => [{:z=>1}, {}, {:z2=>"2"}] }}
    b = {:b=> {:c => [ {}, {:z2=>"2"}, {:z=>1}], :a=>1}, :a=>1}

    assert_equal [], diff(a,b)

    a = {:z => [{}, {:a => {:b => [1,2]}}]}
    b = {:z => [{:a => {:b => [1,2]}}, {}]}

    assert_equal [], diff(a,b)

    b = {:z => [{}, {:a => {:b => [2,1]}}]}

    assert_equal [], diff(a,b)

    a = {:z => [{}, {:a => {:b => [{:c => 3}, {:d => 4}]}}]}
    b = {:z => [{}, {:a => {:b => [{:d => 4}, {:c => 3}]}}]}

    assert_equal [], diff(a,b)
    
  end

end

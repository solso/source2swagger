require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class SwaggerReaderTest < Test::Unit::TestCase

  def setup
    $_swaggerhash = Hash.new
  end 
 
  def test_swagger_simple
  
    sapi = SwaggerHash::namespace("test")
    ep = sapi.endpoint.add
    ep.set :path => "/sentence/{sentence}", :format => "json"
    ep.description = "Returns the aggregated sentiment of a sentence"
  
    expected = {:endpoint => [{:path => "/sentence/{sentence}", :format => "json", :description => "Returns the aggregated sentiment of a sentence"}]}  
    assert_equal $_swaggerhash["test"].to_hash, expected
    
    $_swaggerhash = Hash.new
      
    code = ["sapi = SwaggerHash::namespace(\"test\")", "ep = sapi.endpoint.add", "ep.set :path => \"/sentence/{sentence}\", :format => \"json\"", "ep.description = \"Returns the aggregated sentiment of a sentence\""]
    code << "$_swaggerhash[\"test\"].to_hash"
    res = eval(code.join(";"))
    assert_equal res, expected  
    
  end
  
  def test_samples_1
    
    reader = SwaggerReader.new

    code = reader.analyze_file("#{File.dirname(__FILE__)}/../data/sample1.rb","##~")

    api1 = reader.process_code(code)
    
    api1 = api1["sentiment"].to_hash
    
    api2 = JSON::load(File.new("#{File.dirname(__FILE__)}/../data/sample1.json","r"))

    assert_equal [], diff(api1, api2)  
  
  end
 
  def test_samples_2
    
    reader = SwaggerReader.new
    
    code = reader.analyze_file("#{File.dirname(__FILE__)}/../data/sample2.rb","##~")
    api1 = reader.process_code(code)
    
    api1 = api1["sentiment"].to_hash
    
    api2 = JSON::load(File.new("#{File.dirname(__FILE__)}/../data/sample2.json","r"))

    assert_equal [], diff(api1, api2)  
  
  end

  def test_samples_3
    
    reader = SwaggerReader.new
    
    code = reader.analyze_file("#{File.dirname(__FILE__)}/../data/sample3.rb","##~")
    api1 = reader.process_code(code)
    
    api1 = api1["sentiment"].to_hash
    
    api2 = JSON::load(File.new("#{File.dirname(__FILE__)}/../data/sample3.json","r"))

    assert_equal [], diff(api1, api2)  
  
  end

  def test_samples_4
    
    ## sample4.rb is same as sample2.rb with the use of variables
    
    reader = SwaggerReader.new
    
    code = reader.analyze_file("#{File.dirname(__FILE__)}/../data/sample4.rb","##~")
    api1 = reader.process_code(code)
    api1 = api1["sentiment"].to_hash
    
    api2 = JSON::load(File.new("#{File.dirname(__FILE__)}/../data/sample2.json","r"))

    assert_equal [], diff(api1, api2)  
  
  end


  def test_incorrect_samples
    
    reader = SwaggerReader.new
    
    code = reader.analyze_file("#{File.dirname(__FILE__)}/../data/sample1.rb","##~")
    api1 = reader.process_code(code)
    
    api1 = api1["sentiment"].to_hash
    
    api2 = JSON::load(File.new("#{File.dirname(__FILE__)}/../data/sample2.json","r"))

    assert_not_equal [], diff(api1, api2)

    api3 = JSON::load(File.new("#{File.dirname(__FILE__)}/../data/sample3.json","r"))
    assert_not_equal [], diff(api1, api3)
  

  end

  def test_exception_single_file

    reader = SwaggerReader.new
    
    begin
      code = reader.analyze_file("#{File.dirname(__FILE__)}/../data/sample_bad2.rb","##~")
      api1 = reader.process_code(code)
      assert_equal true, false
    rescue Exception => e
      assert_equal "Error parsing source files at #{File.dirname(__FILE__)}/../data/sample_bad2.rb:9\n#<SyntaxError: (eval):1: unterminated string meets end of file>", e.to_s
    end

  end


  def test_exception_all_files

    reader = SwaggerReader.new
    
    begin
      code = reader.analyze_all_files("#{File.dirname(__FILE__)}/../data","rb","##~")
      api1 = reader.process_code(code)
      assert_equal true, false
    rescue Exception => e
      assert_equal "Error parsing source files at #{File.dirname(__FILE__)}/../data/sample_bad1.rb:17\n#<SyntaxError: (eval):1: syntax error, unexpected keyword_end, expecting $end\n...=> \"API down\", :code => 500;end = a.operations.add;out = {:a...\n...                               ^>", e.to_s
    end

  end

  def test_exception_variable_not_defined

    reader = SwaggerReader.new
    
    begin
      code = reader.analyze_file("#{File.dirname(__FILE__)}/../data/sample_bad3.rb","##~")
      api1 = reader.process_code(code)
      assert_equal true, false
    rescue Exception => e
      assert_equal "Error parsing source files at #{File.dirname(__FILE__)}/../data/sample_bad3.rb:17\n#<NoMethodError: undefined method `to_hash' for nil:NilClass>", e.to_s
    end

  end

end

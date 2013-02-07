require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class SwaggerReaderTest < Test::Unit::TestCase

  def setup
    source2swagger = SwaggerHash.new
  end 
 
  def test_swagger_simple
  
    source2swagger = SwaggerHash.new
    sapi = source2swagger.namespace("test")
    ep = sapi.endpoint.add
    ep.set :path => "/sentence/{sentence}", :format => "json"
    ep.description = "Returns the aggregated sentiment of a sentence"
  
    expected = {:endpoint => [{:path => "/sentence/{sentence}", :format => "json", :description => "Returns the aggregated sentiment of a sentence"}]}  
    assert_equal source2swagger.namespace("test").to_hash, expected
    
    
      
    code = ["source2swagger = SwaggerHash.new", "sapi = source2swagger.namespace(\"test\")", "ep = sapi.endpoint.add", "ep.set :path => \"/sentence/{sentence}\", :format => \"json\"", "ep.description = \"Returns the aggregated sentiment of a sentence\""]
    code << "source2swagger.namespace(\"test\").to_hash"
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
      assert_equal "Error parsing source files at #{File.dirname(__FILE__)}/../data/sample_bad2.rb:9", e.message.split("\n").first
    end

  end

  def test_exception_all_files

    reader = SwaggerReader.new
    
    begin
      code = reader.analyze_all_files("#{File.dirname(__FILE__)}/../data","rb","##~")
      api1 = reader.process_code(code)
      assert_equal true, false
    rescue Exception => e
      assert_equal "Error parsing source files at #{File.dirname(__FILE__)}/../data/sample_bad1.rb:17", e.message.split("\n").first
    end

  end

  def test_exception_variable_not_defined

    reader = SwaggerReader.new
    
    begin
      code = reader.analyze_file("#{File.dirname(__FILE__)}/../data/sample_bad3.rb","##~")
      api1 = reader.process_code(code)
      assert_equal true, false
    rescue Exception => e
      assert_equal "Error parsing source files at #{File.dirname(__FILE__)}/../data/sample_bad3.rb:17", e.message.split("\n").first

    end
  end

  def test_unordered_variables_do_not_matter
    
    reader = SwaggerReader.new
    
    code = reader.analyze_file("#{File.dirname(__FILE__)}/../data/sample5.rb","##~")
    api1 = reader.process_code(code)
    api1 = api1["sentiment"].to_hash
    
    api2 = JSON::load(File.new("#{File.dirname(__FILE__)}/../data/sample2.json","r"))

    assert_equal [], diff(api1, api2) 
  end

  def test_safe_level
    
    assert_raises SwaggerReaderException do
      reader = SwaggerReader.new

      code = {:code => [], :line_number => [], :file => []}
   
      code[:code] << "system \"rm -rf /tmp/test.txt\""
      code[:line_number] << 0
      code[:file] << "foo"

      reader.process_code(code)
    end
  end
  
  def test_missing_ad_sign
    ## https://github.com/solso/source2swagger/issues/6
    reader = SwaggerReader.new
    code = reader.analyze_file("#{File.dirname(__FILE__)}/../data/sample6.rb","##~")
    api1 = reader.process_code(code)
    assert_equal "<%= @base_path %>", api1["sentiment"][:basePath]
  end

  def test_response_class
    reader = SwaggerReader.new
    code = reader.analyze_file("#{File.dirname(__FILE__)}/../data/sample7.rb","##~")
    api1 = reader.process_code(code)

    # check swagger version
    assert_equal api1["helloWorld"][:swaggerVersion], "0.1a"

    api = api1["helloWorld"][:apis][0]
    op = api[:operations][0]

    # check model
    assert_equal op[:responseClass], "HelloMessage"
  end


  def test_models
    reader = SwaggerReader.new
    code = reader.analyze_file("#{File.dirname(__FILE__)}/../data/sample7.rb","##~")
    api1 = reader.process_code(code)

    # check swagger version
    assert_equal api1["helloWorld"][:swaggerVersion], "0.1a"

    model = api1["helloWorld"][:models]["HelloMessage"]
    assert_equal model[:id], "HelloMessage"

    properties = model[:properties]
    assert_equal properties[:id], {:type => "long"}
    assert_equal properties[:name], {:type => "string"}
  end
end

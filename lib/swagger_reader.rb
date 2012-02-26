
class SwaggerReader

  #def analyze(line)
  #  return nil unless line.strip!.match(/^##~/)
  #  return line.gsub!("##~","").strip!
  #end

  def analyze_file(file, comment_str)

    code = {:code => [], :line_number => [], :file =>[]}

    File.open(file,"r") do |f|
      line_number = 1
      while (line = f.gets)
        v = line.strip!.split(" ")
        if !v.nil? && v.size > 0 && (v[0]==comment_str)        
          code[:code] << v[1..v.size].join(" ")
          code[:file] << file
          code[:line_number] << line_number
        end
        line_number = line_number + 1
      end
    end 

    return code

  end

  def analyze_all_files(base_path, file_extension, comment_str)

    code = {:code => [], :line_number => [], :file =>[]}

    files = Dir["#{base_path}/**/*.#{file_extension}"].sort

    files.each do |file| 
      fcode = analyze_file(file,comment_str)
      [:code, :line_number, :file].each do |lab|
        code[lab] = code[lab] + fcode[lab]
      end
    end 

    return code

  end
  
  def process_code(code)

    code[:code].size.times do |cont|
      $_swaggerhash = Hash.new
      begin
        v = code[:code][0..cont]
        v << "out = {:apis => []}"
        v << "$_swaggerhash.each {|k,v| out[k] = v.to_hash}"
        eval(v.join(";"))
      rescue Exception => e
        raise SwaggerReaderException, "Error parsing source files at #{code[:file][cont]}:#{code[:line_number][cont]}\n#{e.inspect}"
      end
    end
    $_swaggerhash = Hash.new  

    code[:code] << "out = {:apis => []}"
    code[:code] << "$_swaggerhash.each {|k,v| out[k] = v.to_hash}"
  
    res = eval(code[:code].join(";"))

    res.each do |k, v|
      res[k] = v.to_hash
    end

    res  
  end

end

class SwaggerReaderException < Exception

end


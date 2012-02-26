
class SwaggerReader

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

  def sort_for_vars_declaration(code)

    tmp_vars = {:code => [], :line_number => [], :file =>[]}
    tmp_not_vars = {:code => [], :line_number => [], :file =>[]}

    cont = 0
    code[:code].each do |code_line|
      code_line.strip!        
      if code_line[0]=='@'
        tmp_vars[:code] << code_line
        tmp_vars[:line_number] << code[:line_number][cont]
        tmp_vars[:file] << code[:file][cont]
      else
        tmp_not_vars[:code] << code_line
        tmp_not_vars[:line_number] << code[:line_number][cont]
        tmp_not_vars[:file] << code[:file][cont]
      end
      cont=cont+1
    end

    res = {:code => tmp_vars[:code] + tmp_not_vars[:code], :line_number => tmp_vars[:line_number] + tmp_not_vars[:line_number], :file => tmp_vars[:file] + tmp_not_vars[:file]}

    return res

  end

 
  def process_code(code)

    code = sort_for_vars_declaration(code)

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


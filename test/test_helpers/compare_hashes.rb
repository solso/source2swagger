module TestHelpers
  module CompareHashes

    def paths(path,h)
      
      if h.class==Hash
        v = []
        h.each do |k,val|
          v << paths("#{path}/#{k}",val)
        end
        return v.flatten
      else
        if h.class==Array
          v = []
          if h.size>0
            h.each do |item|
              v << paths("#{path}/[]",item)
           end
          else
            v << ["#{path}/[]"]
          end
        
          return v.flatten
        else
          return ["#{path}/#{h}:(#{h.class})"]
        end
      end
    end

    def diff(h1, h2)
      
      v1 = paths("",h1)
      v2 = paths("",h2)

      return [] if v1.size==v2.size && v1-v2 == []

      v1 = v1.sort
      v2 = v2.sort

      num = v1.size
      num = v2.size if v2.size < num

      v1.size.times do |i|
        if v1[i]!=v2[i]
          return [v1[i], v2[i]]
        end
      end

      return [nil, nil]

    end  
  end
end

Test::Unit::TestCase.send(:include, TestHelpers::CompareHashes)



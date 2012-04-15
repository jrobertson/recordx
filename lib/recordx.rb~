#!/usr/bin/env ruby

# file: recordx.rb

class RecordX

  def initialize(callerx, id, h={})

    @callerx, @id = callerx, id
    
    methods = h.to_a.map do |k,v| 
      name, val = k.to_s, v
      "def #{name}=(s) @#{name} = s.to_s; @callerx.update(@id, #{name}: s.to_s) end\n\
        def #{name}() @#{name} end\n\
        @#{name} = '#{val}'"
    end
    self.instance_eval methods.join("\n")
  end
end  

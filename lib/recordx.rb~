#!/usr/bin/env ruby

# file: recordx.rb

class RecordX

  def initialize(callerx, id, h={})
    @callerx, @id = callerx, id    
    h.each {|name,val| attr_accessor2(name.to_s, val) }
  end

  def method_missing(method_name, *raw_args)
    arg = raw_args.length > 0 ? raw_args.first : nil
    attr_accessor2(method_name[/\w+/], arg)
    arg ? self.send(method_name, arg) : self.send(method_name)    
  end

  def attr_accessor2(name,val=nil)
    self.instance_eval "def #{name}=(s)\n @#{name} = s.to_s\n\
         @callerx.update(@id, #{name}: s.to_s)\n  end\n\
        def #{name}() @#{name} end\n\
        @#{name} = '#{val}'"
  end

end  

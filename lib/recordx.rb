#!/usr/bin/env ruby

# file: recordx.rb

class RecordX

  attr_reader :id
  
  class RXHash < Hash
    def initialize(callerx)
      super()
      @callerx = callerx 
    end

    def []=(name, val)
      unless @callerx.send(name.to_sym) == val then
        @callerx.send((name.to_s + '=').to_sym, val) 
      end
      super(name, val)
    end
  end

  def initialize(h={}, callerx=nil, id=nil )

    @callerx, @id = callerx, id    
    @h = RXHash.new(self).merge h
    h.each {|name,val| attr_accessor2(name.to_s, val) }
  end

  def delete()
    @callerx.delete @id
  end

  def h()
    @h
  end

  def inspect()
    "<object #%s>" % [self.object_id]
  end

  alias to_h h

  def update(h)
    h.each {|name,value| self.method((name.to_s + '=').to_sym).call(value) }
  end

  private

  def method_missing(method_name, *raw_args)
    
    if method_name == :[] or method_name == :[]= then
      return @h.send(method_name, *raw_args) 
    end
    
    arg = raw_args.length > 0 ? raw_args.first : nil
    attr_accessor2(method_name[/\w+/], arg)
    arg ? self.send(method_name, arg) : self.send(method_name)    
  end

  def attr_accessor2(name,val=nil)

    reserved_keywords = ( 
                          Object.public_methods | \
                          Kernel.public_methods | \
                          public_methods + [:method_missing]
                        )
    exceptions = [:name]

    if (reserved_keywords - exceptions).include? name.to_sym then
      raise "recordx: reserved keyword *#{name}* can't be used as a field name"
    end
    
    self.instance_eval %Q{
      def #{name}=(s)
        @#{name} = s.to_s
        unless @h[:#{name}] == s.to_s then
          @h[:#{name}] =  s.to_s 
          @callerx.update(@id, #{name}: s.to_s) if @callerx
        end
      end

      def #{name}()
        @#{name}
      end

      @#{name} = %{#{val}}}
  end

end  

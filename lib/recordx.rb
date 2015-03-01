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

  def initialize(x=nil, callerx=nil, id=nil )

    h = if x.is_a? Hash then x
    
      x
      
    elsif x.is_a? Array then
      
      x.inject({}) do |r,y|
        val = y.is_a?(String) ? y.text.unescape : ''
        r.merge(y.name.to_sym => val)
      end
      
    else
      
      x
      
    end
    
    @callerx, @id = callerx, id    
    @h = RXHash.new(self).merge h
    h.each {|name,val| attr_accessor2(name.to_s, val) }
  end
  
  def [](k)      @h[k]         end
  def []=(k,v)   @h[k] = v     end
  def keys()     @h.keys       end
  def values()   @h.keys       end
  def each(&blk) @h.each(&blk) end
  alias each_pair each

  def delete()
    @callerx.delete @id
  end

  def h()
    @h
  end

  def inspect()
    "#<RecordX:%s @h=%s>" % [self.object_id, @h]
  end

  alias to_h h

  def update(h)
    h.each {|name,value| self.method((name.to_s + '=').to_sym).call(value) }
  end

  private

  def method_missing(method_name, *raw_args)
        
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

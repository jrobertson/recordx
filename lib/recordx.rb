#!/usr/bin/env ruby

# file: recordx.rb


require 'rexle'
require 'rexle-builder'


class RecordX
  using ColouredText

  attr_reader :id, :created, :last_modified
  
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
    
    def clone()
      self.to_h.clone
    end
  end

  def initialize(x=nil, callerx=nil, id=nil, created=nil, last_modified=nil, 
                 debug: false)
    
    @debug = debug
    puts ('x: ' + x.inspect).debug if @debug

    h = if x.is_a? Hash then x
    
      x
      
    elsif x.is_a? Array then
      
      x.inject({}) do |r,y|
        val = y.text.is_a?(String) ? y.text.unescape : ''
        r.merge(y.name.to_sym => val)
      end
      
    else
      
      x
      
    end
    
    @callerx, @id, @created, @last_modified = callerx, id, \
                                                         created, last_modified
    @h = RXHash.new(self).merge h
    h.each {|name,val| attr_accessor2(name.to_s, val) }
    
  end
  
  def [](k)      @h[k]         end
  def []=(k,v)   @h[k] = v     end
  def keys()     @h.keys       end
  def values()   @h.values     end
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

  def to_h()
    @h.clone
  end
    
  def to_html(xslt: '')

    # This method is expected to be used within Dynarex
    
    kvx = self.to_kvx

    xsl_buffer = RXFHelper.read(xslt).first
    #jr100316 xslt  = Nokogiri::XSLT(xsl_buffer)
    #jr100316 xslt.transform(Nokogiri::XML(kvx.to_xml)).to_s 
    Rexslt.new(xsl_buffer, kvx.to_xml).to_s

  end
  
  def to_kvx()
    
    puts 'inside to_kvx'.info if @debug
    kvx = Kvx.new(@h.to_h, debug: @debug)
    
    if @callerx and @callerx.summary[:recordx_type] then
      summary_fields = @callerx.summary.keys - [:recordx_type, \
                                          :format_mask, :schema, :default_key]
      summary_fields.each {|field| kvx.summary[field] = @callerx.summary[field] }
    end
    
    kvx
    
  end
  
  def to_s()
    self.to_kvx.to_s
  end
  
  def to_xml()

    def build(xml, h)
      h.each_pair {|key, value| xml.send(key.to_sym, value) }
    end

    xml = RexleBuilder.new

    Rexle.new(xml.root { build xml, h }).xml pretty: true    
  end

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
    exceptions = [:name, :id]

    if (reserved_keywords - exceptions - @h.keys).include? name.to_sym then
      raise "recordx: reserved keyword *#{name}* can't be used as a field name"
    end
    
    self.instance_eval %Q{
      
      def #{name}=(s)
        
        puts 'inside #{name} assignment' if @debug
        
        @#{name} = s.to_s
        unless @h[:#{name}] == s.to_s then
          @h[:#{name}] =  s.to_s
          @callerx.update(@id, #{name}: s.to_s) if @callerx
        end
      end

    }
    
    # If this method has been monkey patched don't attempt to overwrite it
    
    if not self.public_methods.include? name.to_sym then
      self.instance_eval %Q{    
        def #{name}()
          @#{name}
        end
      }
    end
    
    self.method((name + '=').to_sym).call val if val
    
  end

end  

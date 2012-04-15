#Introducing the RecordX gem

The RecordX gem is a convenient way of storing names and values accessible from either the hash syntax or the method syntax e.g.

    require 'recordx'

    rec = RecordX.new()
    rec.to_h #=> {}

    rec.fruit = 'apple'
    rec.to_h #=> {:fruit=>"apple"}

    rec.h[:fruit] = 'banana'
    rec.to_h #=> {:fruit=>"banana"}
    rec.day = 'Sunday' #=> {:fruit=>"banana", :day=>"Sunday"}

It can also use a hash passed in when the object is initialised e.g.

    rec = RecordX.new({car: 'electric', country: 'France'})
    puts "I would like to drive the #{rec.car} car in #{rec.country}"
    #=> I would like to drive the electric car in France

The RecordX object can be embedded within a consumer object and will notify it when a record value has changed e.g.

    class Fun

      def record()
        RecordX.new({time: 'morning', day: 'Friday'}, self, id='100')
      end

      def update(id='', key_pair)
        puts "ready to update record '%s' using name '%s' and value '%s'" % \
          ([id] + key_pair.to_a.first)
      end
    end

    fun = Fun.new
    rec = fun.record
    puts rec.day #=> 'Friday'
    rec.day = 'Saturday'
    puts rec.day #=> 'Saturday'

## Resources

* [jrobertson/recordx](https://github.com/jrobertson/recordx)


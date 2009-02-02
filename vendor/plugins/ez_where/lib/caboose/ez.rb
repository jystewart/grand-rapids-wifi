
module Caboose

  module EZ
    #
    # EZ::Condition plugin for generating the :conditions where clause
    # for ActiveRecord::Base.find. And an extension to ActiveRecord::Base
    # called AR::Base.find_with_conditions that takes a block and builds
    # the where clause dynamically for you.
    #
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval { extend Caboose::EZ::SingletonMethods }
    end

    module ClassMethods
      # allows you to use the following block form for find_with_conditions:
      # add :or => true to the options hash if you want to join the conditions 
      # with OR instead of AND. AND is the default.
      # Model.find_with_conditons( :all, :or => true, :limit => ..., :order => ... ) do
      #   foo == 'bar'       # ["foo = ?", "bar"]
      #   baz <=> (1..100)   # ["baz BETWEEN ? AND ?", 1, 100]
      #   woo =~ '%Ezra%'    # ["woo LIKE ?", "$Ezra%"]
      #   id === (1..5)      # ["IN (?)", [1,2,3,4,5]]
      #   fiz < 10           # <, >, <=, >=, etc., should all "just work"
      # end
      def find_with_conditions(*args, &block)
        cond = Condition.new(&block)
        #p args
        options = args[1].nil? ? {} : args[1]
        #p options
        bool = options.delete(:or)
        #p bool
        bool = bool.nil? ? 'AND' : 'OR'
        options[:conditions]= cond.to_sql(bool)
        #p cond.to_sql(bool)
        self.find( args.first, options )
      end
    end

    module SingletonMethods
      def ez_condition(bool = 'AND', &block)
        Condition.new(table_name, bool, &block)
      end
    end

    class Clause
	    # need this so that id doesn't call Object#id
	    # left it open to add more methodds that
	    # conflict when I find them
	    [:id].each { |m| undef_method m }
      attr_reader :name, :test, :value

      # Initialize a Clause object with the name of the
      # column.    
      def initialize(*args)
        @table_prefix = ''
        case args.length
        when 0:
          raise 'Expected at least one parameter'
        when 1:
          @name = args.first.to_s
        when 2:
          @table_prefix = args.first.to_s + '.' unless args.first.to_s.empty? 
          @name = args.last.to_s
        end
        # prefix with esc_ to avoid clashes with standard methods like 'alias'
        @name = @name.slice(4, @name.length) if @name =~ /^esc_.*/
      end

      # The == operator has been over-ridden here to
      # stand in for an exact match ["foo = ?", "bar"]
      def ==(other)
        @test = :equals
        @value = other
      end

      # The =~ operator has been over-ridden here to
      # stand in for the sql LIKE "%foobar%" clause.
      def =~(pattern)
        @test = :like
        @value = pattern
      end
      
      # The spaceship <=> operator has been over-ridden here to
      # stand in for the sql ["BETWEEN ? AND ?", 1, 5] "%foobar%" clause.
      def <=>(range)
        @test = :between
        @value = range
      end

      # The === operator has been over-ridden here to
      # stand in for the sql ["IN (?)", [1,2,3]] clause.
		  def ===(range)
	      @test = :in
	      @value = range
	    end

      # switch on @test and build appropriate clause to 
      # match the operation.
      def to_sql
        case @test
        when :equals
          ["#{@table_prefix}#{@name} = ?", @value]
        when :like
          ["#{@table_prefix}#{@name} LIKE ?", @value]
        when :between
          ["#{@table_prefix}#{@name} BETWEEN ? AND ?", @value.begin, @value.end]
        when :in
          ["#{@table_prefix}#{@name} IN (?)", @value.to_a]
        else
          ["#{@table_prefix}#{@name} #{@test} ?", @value]
        end
      end

      # This method_missing takes care of setting
      # @test to any operator thats not covered 
      # above. And @value to the value
      def method_missing(name, *args)
        @test = name
        @value = args.first
      end
    end

    class ArrayClause
      
      attr_reader :test
      
      def initialize(cond_array)
        @test = :array
        @cond_array = cond_array
      end
            
      def to_sql
        return nil if @cond_array.first.to_s.empty?
        query = (@cond_array.first =~ /^\([^\(\)]+\)$/) ? "#{@cond_array.first}" : "(#{@cond_array.first})"
        [query, @cond_array[1..@cond_array.length] ]
      end
      
    end

    class SqlClause
      
      attr_reader :test
      
      def initialize(sql)
        @test = :sql
        @sql = sql
      end
      
      def to_sql
        [@sql]
      end
      
    end

    class Condition
	    # need this so that id doesn't call Object#id
	    # lest fi open to add more methodds that
	    # conflict when I find them
	    [:id].each { |m| undef_method m }
      attr_reader :vars
      
      # Initialize @vars and eval the block so 
      # it invokes method_missing.
      def initialize(table_name = nil, bool = 'AND', &block)
        @vars = []; @params = []; @query = []
        @table_name = table_name; @bool = bool
        instance_eval(&block) if block_given?
      end

      # Invoked with the name of the column in each
      # statement inside the block. Then passes the 
      # name to a new Clause instance. Then the operator
      # hits method_missing and gets sent to a new
      # Clause instance where it either matches one of the 
      # defined ops or hits method_missing there.
      def method_missing(name, *args)
        puts "Condition#method_missing(#{([name]+args).join(', ')})" if $DEBUG
        if name.kind_of?(Array)
          cv = Clause.new(name.first, name.last)
        elsif args.last.kind_of?(Symbol)
          cv = Clause.new(args.pop, name)
        else 
          cv = Clause.new(@table_name, name)
        end
        @vars << cv
        cv
      end
      
      def sub_cond(table_name = @table_name, bool=@bool, &block)
        cond = Condition.new(table_name, bool, &block)
        self << cond        
      end

      alias :sub_condition :sub_cond
      alias :sub :sub_cond

      def and_cond(table_name = @table_name, &block)
        sub_condition(table_name, 'AND', &block)
      end
      
      alias :and_condition :and_cond
      alias :cond :and_cond
      alias :and_ :and_cond

      def or_cond(table_name = @table_name, &block)
        sub_condition(table_name, 'OR', &block)
      end

      alias :or_condition :or_cond
      alias :or_ :or_cond

      def <<(condition, bool = nil)
        if condition.kind_of?(String)        
          @vars << SqlClause.new(condition)
        else
          if condition.kind_of?(Condition)
            unless bool.to_s.empty?
              condition = condition.to_sql(bool) 
            else
              condition = condition.to_sql
            end
          end
          @vars << ArrayClause.new(condition) if condition.kind_of?(Array) 
        end       
      end
      
      alias :sql_condition :<<      
      alias :add_sql :<<
      
      # Loop over all Clause onjects in @vars array
      # and call to_sql on each instance. Then join
      # the queries and params into the :conditions
      # array with bool defaulting to AND.
      def to_sql(bool=@bool)
        params = []; query = []
        @vars.each do |cv|
          q, p, e = cv.to_sql                 
          unless q.to_s.empty?
            query << q
            if cv.test == :in 
              params << p if p.respond_to?(:map)
            elsif p.kind_of?(Array)
              p.flatten! unless q =~ /IN/
              params += p
            else
    	        params << p unless p.nil?
    	        params << e unless e.nil?
    	      end  
    	    end       
        end
        bool = bool.to_s.upcase if bool.kind_of?(Symbol)
        [query.join(" #{bool} "), *params ]
      end
    end

  end # EZ module

end # Caboose module
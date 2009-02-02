require 'test/unit'
require 'ez'
class EZWhereTest < Test::Unit::TestCase
  
  def test_ez_where
    
    cond1 = Caboose::EZ::Condition.new :my_table do
      title == 'This is the title in my_table'
      sql_condition 'name IS NULL'
      sub_condition :my_other_table do
        id === [1, 3, 8]
        title == 'This is another title in my_other_table'
        body =~ '%test%'
      end
    end
    
    cond2 = Caboose::EZ::Condition.new :my_table do
      active == true
      archived == false
    end
    
    cond = Caboose::EZ::Condition.new
    cond << cond1
    cond << cond2.to_sql('OR')
    
    
    expected = ["(my_table.title = ? AND name IS NULL AND (my_other_table.id IN (?) AND my_other_table.title = ? AND my_other_table.body LIKE ?)) AND (my_table.active = ? OR my_table.archived = ?)", "This is the title in my_table", [1, 3, 8], "This is another title in my_other_table", "%test%", true, false]
    assert_equal expected, cond.to_sql
  
  
    cond = Caboose::EZ::Condition.new do
      foo == 'bar'
      baz <=> (1..5)
      id === [1, 2, 3, 5, 8]
    end
    
    expected = ["foo = ? AND baz BETWEEN ? AND ? AND id IN (?)", "bar", 1, 5, [1, 2, 3, 5, 8]]
    assert_equal expected, cond.to_sql
    
    cond = Caboose::EZ::Condition.new :my_table do
      foo == 'bar'
      baz <=> (1..5)
      id === [1, 2, 3, 5, 8]
    end
    
    expected = ["my_table.foo = ? AND my_table.baz BETWEEN ? AND ? AND my_table.id IN (?)", "bar", 1, 5, [1, 2, 3, 5, 8]]
    assert_equal expected, cond.to_sql
    
    cond = Caboose::EZ::Condition.new :my_table do
      foo == 'bar'
      baz <=> (1..5)
      id === [1, 2, 3, 5, 8]
      sub_cond :my_other_table do
        fiz =~ '%faz%'
      end
    end
    
    expected = ["my_table.foo = ? AND my_table.baz BETWEEN ? AND ? AND my_table.id IN (?) AND (my_other_table.fiz LIKE ?)", "bar", 1, 5, [1, 2, 3, 5, 8], "%faz%"]
    assert_equal expected, cond.to_sql
   
    cond = Caboose::EZ::Condition.new :my_table do
      foo == 'bar'
      baz <=> (1..5)
      id === [1, 2, 3, 5, 8]
      sub_cond :my_other_table do
        fiz =~ '%faz%'
      end
    end
    
    expected = ["my_table.foo = ? AND my_table.baz BETWEEN ? AND ? AND my_table.id IN (?) AND (my_other_table.fiz LIKE ?)", "bar", 1, 5, [1, 2, 3, 5, 8], "%faz%"]
    assert_equal expected, cond.to_sql
   
    cond_a = Caboose::EZ::Condition.new :my_table do
      foo == 'bar'
      sub_cond :my_other_table do
        id === [1, 3, 8]
        foo == 'other bar'
        fiz =~ '%faz%'
      end
    end
    
    expected = ["my_table.foo = ? AND (my_other_table.id IN (?) AND my_other_table.foo = ? AND my_other_table.fiz LIKE ?)", "bar", [1, 3, 8], "other bar", "%faz%"]
    assert_equal expected, cond_a.to_sql
    
    cond_b = Caboose::EZ::Condition.new :my_table do
      active == true
      archived == false
    end
  
    expected = ["my_table.active = ? AND my_table.archived = ?", true, false]
    assert_equal expected, cond_b.to_sql
  
    composed_cond = Caboose::EZ::Condition.new
    composed_cond << cond_a
    composed_cond << cond_b.to_sql(:or)
    composed_cond << 'fuzz IS NULL'
    
    expected = ["(my_table.foo = ? AND (my_other_table.id IN (?) AND my_other_table.foo = ? AND my_other_table.fiz LIKE ?)) AND (my_table.active = ? OR my_table.archived = ?) AND fuzz IS NULL", "bar", [1, 3, 8], "other bar", "%faz%", true, false]   
    assert_equal expected, composed_cond.to_sql
    
    cond = Caboose::EZ::Condition.new :my_table do
      foo == 'bar'
      or_ :my_other_table do
        baz === ['fizz', 'fuzz']
        biz == 'boz'
      end
    end
    
    expected = ["my_table.foo = ? AND (my_other_table.baz IN (?) OR my_other_table.biz = ?)", "bar", ["fizz", "fuzz"], "boz"]
    assert_equal expected, cond.to_sql
    
    cond = Caboose::EZ::Condition.new :my_table do
      foo == 'bar'
      or_ do
        baz === ['fizz', 'fuzz']
        biz == 'boz'
      end
    end
    
    expected = ["my_table.foo = ? AND (my_table.baz IN (?) OR my_table.biz = ?)", "bar", ["fizz", "fuzz"], "boz"]
    assert_equal expected, cond.to_sql
    
    cond = Caboose::EZ::Condition.new do
      foo == 'bar'
      or_ do
        baz === ['fizz', 'fuzz']
        biz == 'boz'
      end
    end
    
    expected = ["foo = ? AND (baz IN (?) OR biz = ?)", "bar", ["fizz", "fuzz"], "boz"]
    assert_equal expected, cond.to_sql
    
    cond = Caboose::EZ::Condition.new do
      foo == 'bar'
      add_sql ['baz = ? AND bar IS NOT NULL', 'fuzz']
    end
    
    expected = ["foo = ? AND (baz = ? AND bar IS NOT NULL)", "bar", "fuzz"]
    assert_equal expected, cond.to_sql
    
    cond = Caboose::EZ::Condition.new
    cond.foo == 'bar'
    cond << ['baz = ? AND bar IS NOT NULL', 'fuzz']
    
    expected = ["foo = ? AND (baz = ? AND bar IS NOT NULL)", "bar", "fuzz"]
    assert_equal expected, cond.to_sql
      
    # the next tests won't work out-of-the-box because of the Model dependency  
    
   # def self.find_with_block(what, *args, &block)
   #       options = args.last.is_a?(Hash) ? args.last : {}
   #       if block_given?
   #         item_cond = Caboose::EZ::Condition.new(table_name)
   #         content_cond = Caboose::EZ::Condition.new(content_table_name)
   #         yield item_cond, content_cond
   #         condition = Caboose::EZ::Condition.new
   #         condition << item_cond
   #         condition << content_cond
   #         options[:conditions] = condition.to_sql
   #       end
   #       options[:include] ||= []; options[:include] = [options[:include]] if options[:include].kind_of?(String)
   #       options[:include] << :content
   #       self.find(what, options)
   # end    
   # cond = Content::Article.ez_condition { active == true; archived == false }
   # cond.sub_cond(:item_articles, :or) { title =~ '%article%'; title =~ '%first%' }
   # 
   # expected = ["content_items.active = ? AND content_items.archived = ? AND (item_articles.title LIKE ? OR item_articles.title LIKE ?)", true, false, "%article%", "%first%"]
   # assert_equal expected, cond.to_sql
   # 
   # cond = Content::Article.ez_condition { active == true; archived == false }
   # cond.and_ { body =~ '%intro%'; body =~ '%demo%' }
   # cond.or_(:item_articles) { title =~ '%article%'; title =~ '%first%' }
   # 
   # expected = ["content_items.active = ? AND content_items.archived = ? AND (content_items.body LIKE ? AND content_items.body LIKE ?) AND (item_articles.title LIKE ? OR item_articles.title LIKE ?)",
   #  true,
   #  false,
   #  "%intro%",
   #  "%demo%",
   #  "%article%",
   #  "%first%"]
   # assert_equal expected, cond.to_sql
   #         
   # articles = Content::Article.find_with_block(:all, :limit => 1) do |item, content|
   #   item.active == true
   #   item.archived == false
   #   content.title =~ '%article%'
   # end
   # assert_equal 1, articles.length
    
  end
end  
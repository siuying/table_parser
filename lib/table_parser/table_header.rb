module TableParser
  class TableHeader < TableNode
    attr_reader :children
    def initialize(element, rowspan=nil)
      super(element, rowspan)
      @children = []
    end
    
    def size
      @children.size
    end
    
    def [](index)
      @children[index]
    end
    
    def to_s
      "[name=#{text}, children=#{@children.collect{|c| c.to_s }.join(",")}]"
    end
    
  end
end
module TableParser
  class TableColumn < TableNode
    attr_reader :children
    def initialize(element, rowspan=nil, colspan=nil)
      super(element, rowspan, colspan)
      @children = []
    end
    
    def size
      @children.size
    end
    
    def [](index)
      @children[index]
    end
    
    def to_s
      "TableColumn<name=#{text}, children=#{@children.collect{|c| c.to_s }.join(",")}>"
    end
    
  end
end
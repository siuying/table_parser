module TableParser
  class TableNode
    attr_reader :element, :text, :rowspan, :colspan
    def initialize(element, rowspan=nil, colspan=nil)
      @element = element
      @text = element.text      
      @colspan = colspan || element["colspan"].to_i rescue 1
      @rowspan = rowspan || element["rowspan"].to_i rescue 1
    end

    def to_s
      "[#{@text}]"
    end
  end
  
  class EmptyTableNode < TableNode
    def initialize(rowspan=nil, colspan=nil)
      @element = nil
      @text = ""
      @colspan = colspan || element["colspan"].to_i rescue 1
      @rowspan = rowspan || element["rowspan"].to_i rescue 1
    end
  end
end
module TableParser
  class TableNode
    attr_reader :element, :text, :rowspan, :colspan
    def initialize(element, rowspan=nil, colspan=nil)
      @element = element
      @text = element.text.strip rescue ""
      
      if element.nil?
        @colspan = colspan || 1
        @rowspan = rowspan || 1
      else
        @colspan = colspan || element["colspan"].nil? ? 1 : element["colspan"].to_i
        @rowspan = rowspan || element["rowspan"].nil? ? 1 : element["rowspan"].to_i
      end
    end
    
    def span(row, col)
      TableNode.new(element, rowspan-row, colspan-col)
    end

    def to_s
      "[#{@text}]"
    end
  end
  
  class EmptyTableNode < TableNode
    def initialize(rowspan=nil, colspan=nil)
      @element = nil
      @text = ""
      @colspan = colspan || 1
      @rowspan = rowspan || 1
    end
  end
end
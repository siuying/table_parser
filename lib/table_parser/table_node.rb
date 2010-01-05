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
end
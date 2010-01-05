module TableParser
  class TableNode
    attr_reader :element, :text, :rowspan
    def initialize(element, rowspan=nil)
      @element = element
      @text = element.text
    
      if rowspan
        @rowspan = rowspan
      else
        @rowspan = element["rowspan"].to_i rescue 1
      end
    end

    def to_s
      "[#{@text}]"
    end
  end
end
module TableParser
  class TableHeader < TableNode
    attr_reader :children
    def initialize(element, rowspan=nil)
      super(element, rowspan)
      @children = []
    end
  end
end
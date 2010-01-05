module TableParser
  class Table
    attr_reader :nodes, :columns
    def initialize(input, xpath_to_table="//table[0]")
      table = Parser.extract_table(input, xpath_to_table)
      @columns = Parser.extract_column_headers(table)
      @nodes = Parser.extract_nodes(table, @columns)
    end
  
    def to_s
      "Table<#{@headers.collect{|h| h.to_s }.join("\n")}>"
    end

    # get column by index
    def [](index)
      @columns[index]
    end
  end
end
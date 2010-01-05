module TableParser
  class Table
    attr_reader :nodes, :headers
    def initialize(input, xpath_to_table="//table[0]")
      table = Parser.extract_table(input, xpath_to_table)
      @headers = Parser.extract_headers(table)
      @nodes = Parser.extract_nodes(table, @headers)
    end
  
    def to_s
      "Table<#{@headers.collect{|h| h.to_s }.join("\n")}>"
    end
    
    def header_count
      @headers.size
    end
    
    # get column by index
    def [](index)
      @headers[index]
    end
  end
end
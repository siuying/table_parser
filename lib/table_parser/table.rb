module TableParser
  class Table
    attr_reader :nodes, :columns
    def initialize(doc, xpath_to_table="//table[0]", options={})
      if options.has_key?(:header)
        header = options[:header]
      else
        header = true
      end
      
      if options.has_key?(:dup_rows)
        dup_rows = options[:dup_rows]
      else
        dup_rows = true
      end
      
      if options.has_key?(:dup_cols)
        dup_cols = options[:dup_cols]
      else
        dup_cols = true
      end

      table = Parser.extract_table(doc, xpath_to_table)
      @columns = Parser.extract_column_headers(table, dup_rows, dup_cols, header)
      @nodes = Parser.extract_nodes(table, @columns, dup_rows, dup_cols)
    end
  
    def to_s
      "Table<#{@columns.collect{|h| h.to_s }.join(",")}>"
    end

    # get column by index
    def [](index)
      @columns[index]
    end
  end
end
require 'rubygems'
require 'nokogiri'
require 'open-uri'

module TableParser
  class Parser
    # extract_table("http://www.bs4.jp/table/index.html", "/html/body/table/tr/td/table")
    def self.extract_table(input, xpath)
      doc = Nokogiri::HTML(input)

      rows = []      
      table = doc.xpath(xpath)
      rows = table.xpath("./tr").collect do |row|
        row.xpath("./td").collect do |col|
          col
        end
      end  
      rows
    end

    def self.extract_column_headers(rows)
      headers = []
      rows.first.collect do |col|
        header = TableColumn.new(col)
        headers << header

        (header.colspan-1).times do
          headers << TableColumn.new(col)
        end
      end
      rows.delete_at(0)
      headers
    end
    
    def self.extract_nodes(rows, headers)
      data = rows.collect do |row|
        row.collect do |ele|
          node = TableNode.new(ele)
        end
      end

      # handle rowspan
      data.each_index do |row_index|
        row = data[row_index]
        row.each_index do |col_index|
          col = row[col_index]
          headers[col_index].children << col
          
          if col.colspan > 1
            col.insert(col_index, TableNode.new(col.element, col.rowspan, col.colspan - 1))
          end

          if col.rowspan > 1 && data[row_index+1]
            data[row_index+1].insert(col_index, TableNode.new(col.element, col.rowspan - 1))
          end
        end
      end
      
      data
    end
    
  end
end

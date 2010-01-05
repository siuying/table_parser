require 'rubygems'
require 'nokogiri'
require 'open-uri'

module TableParser
  class Parser
    def parse(input, xpath_to_table="//table[0]")
      table = extract_table(input, xpath_to_table)
            
      headers = extract_headers(table)
      contents = extract_content(table)

      data = []
      headers.each do |h|
        data << {:name => h, :data => []}
      end
      
      contents   
    end

    private    
    # extract_table("http://www.bs4.jp/table/index.html", "/html/body/table/tr/td/table")
    def extract_table(input, xpath)
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

    def extract_headers(rows)
      headers = []
      rows.first.collect do |col|
        headers << TableHeader.new(col)
      end
      rows.delete_at(0)
      headers
    end
    
    def extract_content(rows)
      data = rows.collect do |row|
        row.collect do |ele|
          node = TableNode.new(ele)
        end
      end

      data.each_index do |row_index|
        row = data[row_index]
        row.each_index do |col_index|
          col = row[col_index]
          if col.rowspan > 1 && data[row_index+1]
            data[row_index+1].insert(col_index, TableNode.new(col.element, col.rowspan - 1))
          end
        end
      end
      
      data
    end
    
  end
end
require 'rubygems'
require 'nokogiri'
require 'open-uri'

module TableParser
  VERSION = '0.1.0'

  class Parser
    def parse(input, xpath_to_table="//table[0]")
      table = extract_table(input, xpath_to_table)
      
      headers = extract_headers(table)
      contents = extract_content(table)
      
      data = []
      headers.each do |h|
        data << {:name => h, :data => []}
      end

      contents.each do |row|
        puts "row/#{row.length}"
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
    end

    def extract_headers(rows)
      headers = []
      rows.first.collect do |col|
        headers << col.text
      end
      headers
    end
    
    def extract_content(rows)
      data = rows.clone
      for i in (0..data.length-1)
        row = data[i]
        for j in (0..row.length-1)
          col = row[j]
          if !col.nil? && col.class != String
            rowspan = col["rowspan"].to_i rescue 1
            row[j] = col.text || " "
            if rowspan > 1
              rowspan -= 1
              for addrow in (1..rowspan)
                data[i + addrow].insert(j+1, col.text)
              end
            end
          end
        end      
      end
      data[0..10]
    end
    
  end
end

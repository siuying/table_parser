require "test/unit"
require "lib/table_parser"

class TestTableParser < Test::Unit::TestCase
  def test_parse_simple
    parser = TableParser::Parser.new
    table = parser.parse "<html><body><table><tr><td>A</td><td>B</td></tr>\
      <tr><td rowspan=\"2\">1</td><td>2</td></tr> \
      <tr><td>3</td></tr></table></body></html>", 
      "/html/body/table"

    assert(table.size == 2, 'number of row should = 2 ')
    assert(table[0].size == 2, 'number of col of row 1 = 2 ')
    assert(table[1].size == 2, 'number of col of row 2 = 2 ')
  end
  
  def test_parse_complex
    parser = TableParser::Parser.new
    table = parser.parse open("http://www.bs4.jp/table/index.html").read, 
      "/html/body/table/tr/td/table"
  end
  

end

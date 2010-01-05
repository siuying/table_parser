require "test/unit"
require "table_parser"

class TestTableParser < Test::Unit::TestCase
  def test_parse_simple
    parser = TableParser::Parser.new
    table = parser.parse "<html><body><table><tr><td>A</td><td>B</td></tr>\
      <tr><td rowspan=\"2\">1</td><td>2</td></tr> \
      <tr><td>3</td></tr></table></body></html>", 
      "/html/body/table"

    assert_equal(3, table.size, 'number of row should = 2 ' + table.join(","))
    assert_equal(2, table[0].size, 'number of col of row 1 = 2 ')
    assert_equal(2, table[1].size, 'number of col of row 2 = 2 ')
  end
  
  def test_parse_complex
    parser = TableParser::Parser.new
    table = parser.parse "<html><body><table><tr><td>Header1</td><td>Header2</td><td>Header3</td><td>Header4</td></tr>\
    <tr><td rowspan=\"3\">A1</td><td>A2</td><td rowspan=\"2\">A3</td><td>B4</td></tr>\
    <tr><td>B2</td><td>B4</td></tr>\
    <tr><td>C2</td><td>C3</td><td>B4</td></tr>\
    </table></body></html>", 
      "/html/body/table"
      
    assert_equal 4, table.size
    assert_equal 4, table[0].size
    assert_equal 4, table[1].size
    assert_equal 4, table[2].size
    assert_equal 4, table[3].size
  end

  def test_parse_complex2
    parser = TableParser::Parser.new
    table = parser.parse "<html><body><table><tr><td>Header1</td><td>Header2</td><td>Header3</td><td>Header4</td></tr>\
    <tr><td rowspan=\"3\">A1</td><td>A2</td><td rowspan=\"2\">A3</td><td>A4</td></tr>\
    <tr><td>B2</td><td>B4</td></tr>\
    <tr><td>C2</td><td rowspan=\"2\">C3</td><td>C4</td></tr>\
    <tr><td rowspan=\"3\">D1</td><td>D2</td><td>D4</td></tr>\
    <tr><td>E2</td><td rowspan=\"2\">E3</td><td>E4</td></tr>\
    <tr><td>F2</td><td>F4</td></tr>\
    <tr><td rowspan=\"3\">G1</td><td>G2</td><td rowspan=\"2\">G3</td><td>G4</td></tr>\
    <tr><td>H2</td><td>H4</td></tr>\
    <tr><td>I2</td><td>I3</td><td>I4</td></tr>\
    </table></body></html>", 
      "/html/body/table"
      
    puts table.collect(){|r| r.collect(){|c| "#{c}"}.join(",") + "\n" }.join

    assert_equal 10, table.size
    assert_equal 4, table[0].size
    assert_equal 4, table[1].size
    assert_equal 4, table[2].size
    assert_equal 4, table[3].size
    assert_equal 4, table[4].size
    assert_equal 4, table[5].size
    assert_equal 4, table[6].size
    assert_equal 4, table[7].size
    assert_equal 4, table[8].size
    assert_equal 4, table[9].size
  end
  
  def test_parse_web
    parser = TableParser::Parser.new
    table = parser.parse open("test.html").read, 
      "/html/body/table"

    puts table.collect(){|r| "[" + r.collect(){|c| "#{c}"}.join(",") + "]\n" }.join
  end
end

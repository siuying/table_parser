require "test/unit"
require "table_parser"
require 'iconv'
require 'open-uri'

class TestTableParser < Test::Unit::TestCase
  def test_parse_rowspan
    html = <<EOF
    <html><body><table>

    <tr><td>A</td><td>B</td></tr>
    <tr><td rowspan="2">1</td><td>2</td></tr> 
    <tr><td rowspan="2">3</td></tr>
    <tr><td>4</td></tr>

    </table></body></html>
EOF
    doc = Nokogiri::HTML(html)
    table = TableParser::Table.new doc, "/html/body/table", {:dup_rows => false, :dup_cols => false}
    assert_equal(2, table.columns.size, 'header_count should = 2 ')
    assert_equal(2, table[0].size)
    assert_equal(2, table[1].size)

    table = TableParser::Table.new doc, "/html/body/table", {:dup_rows => true, :dup_cols => false}
    assert_equal(2, table.columns.size, 'header_count should = 2 ')
    assert_equal(3, table[0].size)
    assert_equal(3, table[1].size)
    
    table = TableParser::Table.new doc, "/html/body/table", {:dup_rows => false, :dup_cols => true}
    assert_equal(2, table.columns.size, 'header_count should = 2 ')
    assert_equal(2, table[0].size)
    assert_equal(2, table[1].size)

    table = TableParser::Table.new doc, "/html/body/table", {:dup_rows => true, :dup_cols => true}
    assert_equal(2, table.columns.size, 'header_count should = 2 ')
    assert_equal(3, table[0].size)
    assert_equal(3, table[1].size)

  end
  
  def test_parse_rowspan_disable_dup
    html = "<html><body><table><tr><td>A</td><td>B</td></tr>\
      <tr><td rowspan=\"2\">1</td><td>2</td></tr> \
      <tr><td>3</td></tr></table></body></html>"
    doc = Nokogiri::HTML(html)
    table = TableParser::Table.new doc, "/html/body/table", {:dup_rows => false}

    assert_equal(2, table.columns.size, 'header_count should = 2 ')
    assert_equal(1, table[0].size)
    assert_equal(2, table[1].size)
  end
  
  def test_parse_colspan
    html = <<EOF
    <html><body><table>
    <tr><td>A</td><td colspan="2">B</td></tr>
    <tr><td rowspan="2">A1</td><td>B1</td><td>C1</td></tr> 
    <tr><td>B2</td><td>C2</td></tr>
    <tr><td>A3</td><td>B3</td><td>C3</td></tr>
    <tr><td>A4</td><td colspan="2" rowspan="2">B4</td></tr>
    <tr><td>A5</td></tr>
    <tr><td rowspan="2">A1</td><td>B1</td><td>C1</td></tr> 
    <tr><td>B2</td><td>C2</td></tr>
    <tr><td>A3</td><td>B3</td><td>C3</td></tr>
    <tr><td>A4</td><td colspan="2" rowspan="2">B4</td></tr>
    <tr><td>A5</td></tr>
    </table></body></html>
EOF
    doc = Nokogiri::HTML(html)
    table = TableParser::Table.new doc, "/html/body/table"
    assert_equal(3, table.columns.size, 'header_count should = 3 ')
    assert_equal(10, table[0].size)
    assert_equal(10, table[1].size)
    assert_equal(10, table[2].size)

    table = TableParser::Table.new doc, "/html/body/table", {:dup_rows => false}
    puts table.to_s
    assert_equal(3, table.columns.size, 'header_count should = 3 ')
    assert_equal(8, table[0].size)
    assert_equal(8, table[1].size)
    assert_equal(8, table[2].size)

    table = TableParser::Table.new doc, "/html/body/table", {:dup_rows => false, :dup_cols => false}
    puts table.to_s
    assert_equal(3, table.columns.size, 'header_count should = 3 ')
    assert_equal(8, table[0].size)
    assert_equal(8, table[1].size)
    assert_equal(6, table[2].size)
  end
  
  def test_parse_complex
    html = "<html><body><table><tr><td>Header1</td><td>Header2</td><td>Header3</td><td>Header4</td></tr>\
      <tr><td rowspan=\"3\">A1</td><td>A2</td><td rowspan=\"2\">A3</td><td>B4</td></tr>\
      <tr><td>B2</td><td>B4</td></tr>\
      <tr><td>C2</td><td>C3</td><td>B4</td></tr>\
      </table></body></html>"
    doc = Nokogiri::HTML(html)
    table = TableParser::Table.new doc, "/html/body/table"
      
    assert_equal 4, table.columns.size
    assert_equal 3, table[0].size
    assert_equal 3, table[1].size
    assert_equal 3, table[2].size
  end

  def test_parse_complex2
    html = <<EOF
    <html><body><table><tr><td>Header1</td><td>Header2</td><td>Header3</td><td>Header4</td></tr>
    <tr><td rowspan="3">A1</td><td>A2</td><td rowspan="2">A3</td><td>A4</td></tr>
    <tr><td>B2</td><td>B4</td></tr>
    <tr><td>C2</td><td rowspan="2">C3</td><td>C4</td></tr>
    <tr><td rowspan="3">D1</td><td>D2</td><td>D4</td></tr>
    <tr><td>E2</td><td rowspan="2">E3</td><td>E4</td></tr>
    <tr><td>F2</td><td>F4</td></tr>
    <tr><td rowspan="3">G1</td><td>G2</td><td rowspan="2">G3</td><td>G4</td></tr>
    <tr><td>H2</td><td>H4</td></tr>
    <tr><td>I2</td><td>I3</td><td>I4</td></tr>
    </table></body></html>
EOF
    doc = Nokogiri::HTML(html)
    table = TableParser::Table.new doc, "/html/body/table"

    assert_equal 4, table.columns.size
    assert_equal 9, table[0].size
    assert_equal 9, table[1].size
    assert_equal 9, table[2].size
    assert_equal 9, table[3].size
    
    table = TableParser::Table.new doc, "/html/body/table", {:dup_rows => false}
    puts "table=" + table.to_s
    assert_equal 4, table.columns.size
    assert_equal 3, table[0].size
    assert_equal 9, table[1].size
    assert_equal 5, table[2].size
    assert_equal 9, table[3].size

  end

  def test_parse_noheader
    html = "<html><body><table><tr><td>A</td><td>B</td></tr>\
      <tr><td rowspan=\"2\">1</td><td>2</td></tr> \
      <tr><td>3</td></tr></table></body></html>"
    doc = Nokogiri::HTML(html)
    table = TableParser::Table.new doc, "/html/body/table", {:header => false}

    assert_equal(2, table.columns.size, 'header_count should = 2 ')
    assert_equal(3, table[0].size)
    assert_equal(3, table[1].size)
  end
  
  def test_parse_complex_colrowspan
    html = <<EOF
    <html><body><table><tr><td>A</td><td>B</td><td>C</td><td>D</td><td>E</td></tr>
    <tr><td rowspan="5">1</td><td>2</td><td>3</td><td>4</td><td>5</td></tr>
    <tr><td rowspan="2" colspan="2">2b</td><td>4b</td><td>5b</td></tr> 
    <tr><td rowspan="2">4c</td><td>5c</td></tr>
    <tr><td rowspan="2">2d</td><td>3d</td><td>5d</td></tr>
    <tr><td>3e</td><td>4e</td><td>5e</td></tr>
    </table></body></html>
EOF

    doc = Nokogiri::HTML(html)
    table = TableParser::Table.new doc, "/html/body/table", {:dup_cols => false, :dup_rows => false}
    puts table
    assert_equal(5, table.columns.size, 'header_count should = 5 ')
    assert_equal(1, table[0].size)
    assert_equal(3, table[1].size)
    assert_equal(3, table[2].size)
    assert_equal(4, table[3].size)
    assert_equal(5, table[4].size)
    
    table = TableParser::Table.new doc, "/html/body/table", {:dup_cols => false, :dup_rows => true}
    puts table
    assert_equal(5, table.columns.size, 'header_count should = 5 ')
    assert_equal(5, table[0].size)
    assert_equal(5, table[1].size)
    assert_equal(3, table[2].size)
    assert_equal(5, table[3].size)
    assert_equal(5, table[4].size)
    
    table = TableParser::Table.new doc, "/html/body/table", {:dup_cols => true, :dup_rows => true}
    puts table
    assert_equal(5, table.columns.size, 'header_count should = 5 ')
    assert_equal(5, table[0].size)
    assert_equal(5, table[1].size)
    assert_equal(5, table[2].size)
    assert_equal(5, table[3].size)
    assert_equal(5, table[4].size)
  end
  
  def test_parse_th
    html = <<EOF
    <html><body><table><tr><th>A</th><th>B</th><th>C</th><th>D</th><th>E</th></tr>
    <tr><td rowspan="5">1</td><td>2</td><td>3</td><td>4</td><td>5</td></tr>
    <tr><td rowspan="2" colspan="2">2b</td><td>4b</td><td>5b</td></tr> 
    <tr><td rowspan="2">4c</td><td>5c</td></tr>
    <tr><td rowspan="2">2d</td><td>3d</td><td>5d</td></tr>
    <tr><td>3e</td><td>4e</td><td>5e</td></tr>
    </table></body></html>
EOF

    doc = Nokogiri::HTML(html)
    table = TableParser::Table.new doc, "/html/body/table", {:dup_cols => false, :dup_rows => false}
    puts table
    assert_equal(5, table.columns.size, 'header_count should = 5 ')
    assert_equal(1, table[0].size)
    assert_equal(3, table[1].size)
    assert_equal(3, table[2].size)
    assert_equal(4, table[3].size)
    assert_equal(5, table[4].size)
    
    table = TableParser::Table.new doc, "/html/body/table", {:dup_cols => false, :dup_rows => true}
    puts table
    assert_equal(5, table.columns.size, 'header_count should = 5 ')
    assert_equal(5, table[0].size)
    assert_equal(5, table[1].size)
    assert_equal(3, table[2].size)
    assert_equal(5, table[3].size)
    assert_equal(5, table[4].size)
    
    table = TableParser::Table.new doc, "/html/body/table", {:dup_cols => true, :dup_rows => true}
    puts table
    assert_equal(5, table.columns.size, 'header_count should = 5 ')
    assert_equal(5, table[0].size)
    assert_equal(5, table[1].size)
    assert_equal(5, table[2].size)
    assert_equal(5, table[3].size)
    assert_equal(5, table[4].size)
  end
  
end

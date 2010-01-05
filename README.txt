= TableParser

== DESCRIPTION:

Parsing table could be difficult when its structure contains colspan or rowspan. TableParser parser HTML tables, group them by columns, with colspan and rowspan respected.

== REQUIREMENTS:

* Nokogiri

== INSTALL:

* sudo gem install table_parser


== USAGE:

Use TableParser::Table to create parsed HTML table.

For example, following code:
<pre>
	html = "&lt;html&gt;&lt;body&gt;&lt;table&gt;&lt;tr&gt;&lt;td&gt;A&lt;/td&gt;&lt;td&gt;B&lt;/td&gt;&lt;/tr&gt;\
      &lt;tr&gt;&lt;td rowspan=\"2\"&gt;1&lt;/td&gt;&lt;td&gt;2&lt;/td&gt;&lt;/tr&gt; \
      &lt;tr&gt;&lt;td&gt;3&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;/body&gt;&lt;/html&gt;"
    table = TableParser::Table.new(html, "/html/body/table")
</pre>

Result in following parsed table:

<pre>
Table&lt;TableColumn&lt;name=A, children=[1],[1]&gt;,TableColumn&lt;name=B, children=[2],[3]&gt;&gt;
</pre>
Note the first column contains duplicated item, because the first row contains "rowspan" element. If this is not desired, use following syntax to skip duplication:
<pre>
	html = "&lt;html&gt;&lt;body&gt;&lt;table&gt;&lt;tr&gt;&lt;td&gt;A&lt;/td&gt;&lt;td&gt;B&lt;/td&gt;&lt;/tr&gt;\
      &lt;tr&gt;&lt;td rowspan=\"2\"&gt;1&lt;/td&gt;&lt;td&gt;2&lt;/td&gt;&lt;/tr&gt; \
      &lt;tr&gt;&lt;td&gt;3&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;/body&gt;&lt;/html&gt;"
    table = TableParser::Table.new(html, "/html/body/table", false)
</pre>

Which result in following parsed table:

<pre>
Table&lt;TableColumn&lt;name=A, children=[1],[1]&gt;,TableColumn&lt;name=B, children=[2],[3]&gt;&gt;
</pre>


== DEVELOPERS:

* Francis Chong francis at ignition dot hk

== LICENSE:

The MIT License

Copyright (c) 2010 Ignition Soft

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

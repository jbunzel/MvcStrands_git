Imports Microsoft.VisualBasic
Imports System
Imports System.Data
Imports System.IO
Imports System.Text.RegularExpressions
Imports System.Web
Imports System.Xml
Imports Lucene.Net.Analysis.Standard
Imports Lucene.Net.Documents
Imports Lucene.Net.QueryParsers
Imports Lucene.Net.Search
'Imports Lucene.Net.Search.Highlight


Namespace RQLucene

    Public Class Searcher

        Protected xNode As XmlNode
        Protected indexDirectory As String
        Protected Results As DataTable = New DataTable
        Private startAt As Integer
        Private fromItem As Integer
        Private toItem As Integer
        Private total As Integer
        Private duration As TimeSpan = System.TimeSpan.Zero
        Private ReadOnly maxResults As Integer = 50000


        Public ReadOnly Property ResultTable() As DataTable
            Get
                Return Results
            End Get
        End Property


        Public ReadOnly Property SearchTime() As TimeSpan
            Get
                Return duration
            End Get
        End Property


        Private Function smallerOf(ByVal first As Integer, ByVal second As Integer) As Integer
            If first < second Then
                Return first
            Else
                Return second
            End If
        End Function


        Private Function pageCount() As Integer
            '<summary>
            'How many pages are there in the results.
            '</summary>

            Return (total - 1) / maxResults 'floor
        End Function


        Private Function lastPageStartsAt() As Integer
            '<summary>
            'First item of the last page
            '</summary>

            Return pageCount() * maxResults
        End Function


        Private Function initStartAt(ByVal requestStartValue As Integer) As Integer
            '<summary>
            'Initializes startAt value. Checks for bad values.
            '</summary>
            '<returns></returns>

            Try
                Dim sa As Integer = Convert.ToInt32(requestStartValue)

                'too small starting item, return first page
                If sa < 0 Then
                    Return 0
                End If

                'too big starting item, return last page
                If sa >= total - 1 Then
                    Return lastPageStartsAt()
                End If
                Return sa
            Catch
                Return 0
            End Try
        End Function


        Public Sub New(ByVal Node As XmlNode)
            Me.xNode = Node
            Me.indexDirectory = xNode.Attributes("indexFolderUrl").Value
        End Sub


        Public Sub search(ByVal queryStr As String, ByVal from As Integer)
            Dim start As DateTime = DateTime.Now

            'create the result DataTable
            Dim fields As XmlNodeList = Me.xNode.SelectNodes("results/field")
            Dim j As Integer = 0

            For j = 0 To fields.Count - 1
                Me.Results.Columns.Add(fields(j).Attributes("name").Value, Type.GetType("System.String"))
            Next

            'search
            Dim searcher As IndexSearcher = New IndexSearcher(HttpContext.Current.Server.MapPath(indexDirectory))

            Dim query As Query
            Dim queries As XmlNodeList = Me.xNode.SelectNodes("queries/query")
            Dim qryFields() As String = New String(queries.Count - 1) {}
            Dim hits As Hits

            For j = 0 To queries.Count - 1
                qryFields(j) = CType(queries(j).Attributes("field").Value, System.String)
            Next
            query = MultiFieldQueryParser.Parse(queryStr, qryFields, New StandardAnalyzer)
            hits = searcher.Search(query)
            Me.total = hits.Length()
            Me.startAt = initStartAt(from)

            'create highlighter
            'Dim highlighter As QueryHighlightExtractor = New QueryHighlightExtractor(query, New StandardAnalyzer, "<B>", "</B>")

            'how many items we should show - less than defined at the end of the results
            Dim resultsCount As Integer = smallerOf(total, Me.maxResults + Me.startAt)

            Dim i As Integer
            For i = startAt To resultsCount - 1
                'get the document from index
                Dim doc As Document = hits.Doc(i)

                'get the document filename
                'we can't get the text from the index because we didn't store it there
                'Dim path As String = doc.Get("path")
                'this is the place where the documents are stored on the server
                'Dim location As String = Server.MapPath("1.4\" + path)
                'instead, load it from the original location
                'Dim plainText As String
                'Dim sr As StreamReader = New StreamReader(location, System.Text.Encoding.Default)
                'plainText = parseHtml(sr.ReadToEnd())

                'create a new row with the result data
                Dim row As DataRow = Me.Results.NewRow()
                For j = 0 To fields.Count - 1
                    row(fields(j).Attributes("name").Value) = fields(j).Attributes("prefix").Value + doc.Get(fields(j).Attributes("valueField").Value)
                Next
                Me.Results.Rows.Add(row)
            Next
            searcher.Close()

            'result information
            Me.duration = DateTime.Now - start
            Me.fromItem = startAt + 1
            Me.toItem = smallerOf(startAt + maxResults, total)
        End Sub

    End Class

End Namespace

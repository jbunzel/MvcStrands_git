Imports Microsoft.VisualBasic
Imports System
Imports System.Data
Imports System.Web
Imports System.Xml
Imports Lucene.Net.Index
Imports Lucene.Net.Analysis
Imports Lucene.Net.Analysis.Standard


Namespace RQLucene

    Public MustInherit Class Indexer

        Protected xNode As XmlNode


        Protected Sub New(ByVal Node As XmlNode)
            Me.xNode = Node
        End Sub


        Public Sub Generate()
            'Create the Index
            Dim indexFolderUrl As String = xNode.Attributes("indexFolderUrl").Value
            Dim writer As IndexWriter = New IndexWriter(HttpContext.Current.Server.MapPath(indexFolderUrl), New StandardAnalyzer, True)

            IndexRecords(writer)
            writer.Optimize()
            writer.Close()
        End Sub


        Protected MustOverride Sub IndexRecords(ByVal writer As IndexWriter)

    End Class

End Namespace

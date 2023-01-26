

Sub ChangeCellContent()
    Dim i As Long
    Dim value As String
    Dim separator As String
    Dim Length As Long
    Dim Description As String
    Dim SplitText As Variant
    Dim MsgName As String
    
    separator = """: """
    For i = 1 To Worksheets("Tabelle1").UsedRange.Rows.Count
    ' For i = 1 To 2
        value = Cells(i, 3).value
        Debug.Print value
        If Not IsEmpty(value) Then
            SplitText = Split(value, separator)
            If UBound(SplitText) > 0 Then
                ' Replace quotation marks
                MsgName = Trim(SplitText(0))
                MsgName = Replace(MsgName, Chr(34), "")
                
                ' Cut off trailing quotation marks
                Description = Trim(SplitText(1))
                Description = Mid(Description, 1, Len(Description) - 2)
                
                Debug.Print "Name:        " & MsgName
                Debug.Print "Description: " & Description
                
                'If False Then
                Cells(i, 1).value = Trim(MsgName)
                Cells(i, 2).value = Trim(Description)
                ' Cells(i, 3).value = ""
                ' End If
            End If
            
        End If
    Next i
End Sub
 
 

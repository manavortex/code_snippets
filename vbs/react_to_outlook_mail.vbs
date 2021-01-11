Function ContainsText(olMail As Outlook.MailItem, Str As String) ' As Boolean
     Dim Reg1 As New RegExp
     
     Dim NumMatches As MatchCollection
     Dim M As Match
     
     olMail.BodyFormat = Outlook.OlBodyFormat.olFormatPlain
    ' Debug.Print olMail.Body
     
    'this pattern looks for 4 digits in the subject
      With Reg1
            .pattern = Str
            .Global = True
        End With
    
    ' use this if you need to use different patterns.
    ' regEx.Pattern = regPattern
    
     Set NumMatches = Reg1.Execute(olMail.Body)
     
     If NumMatches.Count = 0 Then
          ContainsText = False
     Else
      ContainsText = True
     End If
     code = ExtractText
 End Function




Function GetFolder(ByVal FolderPath As String) As Outlook.Folder
    Dim TestFolder As Outlook.Folder
    Dim TestFolder2 As Outlook.Folder
     Dim oFolder As Outlook.Folder

    Dim olNs As Outlook.NameSpace
    Dim FoldersArray As Variant
    Dim i As Integer
 
    On Error GoTo GetFolder_Error
    If Left(FolderPath, 2) = "\\" Then
        FolderPath = Right(FolderPath, Len(FolderPath) - 2)
    End If
    
    'Convert folderpath to array
    FoldersArray = Split(FolderPath, "\")
    
    Set olNs = Application.GetNamespace("MAPI")
 
    Set TestFolder = olNs.GetDefaultFolder(olFolderInbox) _
                    .Parent.Folders(FoldersArray(0))

    If Not TestFolder Is Nothing Then
        For i = 1 To UBound(FoldersArray, 1)
            Dim SubFolders As Outlook.Folders
            Set SubFolders = TestFolder.Folders
            Set TestFolder = SubFolders.Item(FoldersArray(i))
            If TestFolder Is Nothing Then
                Set GetFolder = Nothing
            End If
        Next
    End If
     
   'Return the TestFolder
    Set GetFolder = TestFolder
    Exit Function
     
GetFolder_Error:
    Set GetFolder = Nothing
    Exit Function
End Function


Sub MoveItem(FolderPath As String, Item As Outlook.MailItem)
    
    Dim destinationFolder As Outlook.Folder
    
    Set destinationFolder = GetFolder(FolderPath)
    
    If Not (destinationFolder Is Nothing) Then
        Item.Move destinationFolder
    End If

End Sub


Sub CustomMailMessageRule(Item As Outlook.MailItem)
        
    If ContainsText(Item, ".*\/-\/merge_requests\/") Then
       Call MoveItem("Inbox\gitlab\merge_requests", Item)
    Else
    
    End If
    
    ' If ContainsText(Item, "Assignee: Ewa Baumgarten") Then
    '    Item.Categories = "Assigned to me"
    ' End If
   
End Sub



Sub Macro()
    Dim olMail As Outlook.MailItem
        
    Set olMail = Application.ActiveExplorer().Selection(1)
    Call CustomMailMessageRule(olMail)

End Sub

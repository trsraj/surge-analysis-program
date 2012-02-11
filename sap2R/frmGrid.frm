
'  Copyright 2011 Prof K.Sridharan
'  This file is part of SAP2
'
'    SAP2 is free software: you can redistribute it and/or modify
'    it under the terms of the GNU General Public License as published by
'    the Free Software Foundation, either version 3 of the License, or
'    (at your option) any later version.
'
'    SAP2 is distributed in the hope that it will be useful,
'    but WITHOUT ANY WARRANTY; without even the implied warranty of
'    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'    GNU General Public License for more details.
'
'   You should have received a copy of the GNU General Public License
'    along with SAP2.  If not, see <http://www.gnu.org/licenses/>.


VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "MSFLXGRD.OCX"
Begin VB.Form frmGrid 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Data for Pressure Plot"
   ClientHeight    =   5205
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3420
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5205
   ScaleWidth      =   3420
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox Text2 
      Height          =   195
      Left            =   1560
      TabIndex        =   4
      Top             =   1200
      Width           =   855
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   1200
      TabIndex        =   3
      Top             =   4560
      Width           =   855
   End
   Begin VB.TextBox Text1 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   1920
      TabIndex        =   2
      Text            =   "0"
      Top             =   3960
      Width           =   975
   End
   Begin MSFlexGridLib.MSFlexGrid MSFlexGrid1 
      Height          =   3255
      Left            =   480
      TabIndex        =   0
      Top             =   600
      Width           =   2490
      _ExtentX        =   4392
      _ExtentY        =   5741
      _Version        =   393216
   End
   Begin VB.Label Label1 
      Caption         =   "Add Rows"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   480
      TabIndex        =   1
      Top             =   4080
      Width           =   1335
   End
End
Attribute VB_Name = "frmGrid"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'global declarations guff
Const TOTALCOLUMNS = 2  'Zero based
Dim gSort As Integer
Dim gColumn As Integer
Dim xx As Integer

Private Sub Command1_Click()
  
   ClearGrid

End Sub

Private Sub cmdOK_Click()
Me.Hide
frmOutPut.SetFocus
End Sub

Private Sub Form_Load()
  
   Dim myArray As Variant
   Dim iCount As Integer

   'set array
    
    myArray = Array("Sl. No", "Chainage (m)")
  
   'format MSFlexGrid
   'This format creates 1 fixed row for headings etc.
   'Row for data has no fixed columns
   MSFlexGrid1.Rows = 10
   MSFlexGrid1.Cols = TOTALCOLUMNS  'Non-zero based
   MSFlexGrid1.FixedRows = 1
   MSFlexGrid1.FixedCols = 1
   MSFlexGrid1.FocusRect = flexFocusNone
   MSFlexGrid1.SelectionMode = flexSelectionByRow
  
   'intialise for sorting
   gSort = 1
   gColumn = 0
  
   'add headings to grid
   MSFlexGrid1.Row = 0
   For iCount = 0 To TOTALCOLUMNS - 1 'Zero based
      MSFlexGrid1.ColWidth(iCount) = 1200
      MSFlexGrid1.Col = iCount
      MSFlexGrid1.Text = myArray(iCount)
   Next iCount
  
   For I = 1 To MSFlexGrid1.Rows - 1
       MSFlexGrid1.TextMatrix(I, 0) = I
   Next
   
   
  
   'remove 1st blank row from MSFlexGrid
   'MSFlexGrid1.RemoveItem (1)
  
   'highlight 1st row
   HighLightGridRow (1)
  
  
End Sub

Private Sub MSFlexGrid1_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
     
   'MSFlexGrid has the strange feature of not being able to recognize
   'when the heading of 1st fixed column is clicked on, it calls it Row 1,
   'the Row below this also returns as Row 1.
   'This bit of code below singles out the heading row which is required in
   'this app for sorting the data.
    
    Dim J As Integer
    xx = Text1.Text
    MSFlexGrid1.Rows = 10 + xx
    For J = 1 To MSFlexGrid1.Rows - 1
       MSFlexGrid1.TextMatrix(J, 0) = J
   Next
  
   If y < MSFlexGrid1.RowHeight(MSFlexGrid1.Row) Then
     
      Dim WidthTotal As Long
      Dim I As Integer
     
      WidthTotal = 0
     
      For I = 0 To TOTALCOLUMNS - 1 'Zero based
         WidthTotal = WidthTotal + MSFlexGrid1.ColWidth(I)
         If x < WidthTotal Then
            MSFlexGrid1.Col = I
         Exit For
         End If
      Next I
     
      SortGrid
  
   End If

End Sub

Private Sub SortGrid()
  
   If MSFlexGrid1.Col = gColumn Then
      'toggle sort
      If gSort = 2 Then
         gSort = gSort - 1
      Else
         gSort = gSort + 1
      End If
   Else
      'new column selected sort ascending
      gSort = 1
   End If
  
   'set current grid column
   gColumn = MSFlexGrid1.Col
  
   'sort grid with toggle variable
   MSFlexGrid1.Sort = gSort
  
End Sub

Private Sub HighLightGridRow(iRow As Integer)
  
   MSFlexGrid1.Col = 1
   MSFlexGrid1.Row = iRow
  
   MSFlexGrid1.ColSel = TOTALCOLUMNS - 1 'Zero Based
   MSFlexGrid1.RowSel = iRow
  

End Sub

Sub MSFlexGrid1_KeyPress(KeyAscii As Integer)
   MSHFlexGridEdit MSFlexGrid1, Text2, KeyAscii
End Sub

Sub MsFlexGrid1_DblClick()
   MSHFlexGridEdit MSFlexGrid1, Text2, 32 ' Simulate a space.
End Sub

Sub MSHFlexGridEdit(MSHFlexGrid As Control, _
Edt As Control, KeyAscii As Integer)

' Use the character that was typed.

   Select Case KeyAscii
   ' A space means edit the current text.
   Case 0 To 32
      Edt = MSHFlexGrid1
      Edt.SelStart = 1000
   ' Anything else means replace the current text.
   Case Else
      Edt = Chr(KeyAscii)
      Edt.SelStart = 1
      End Select
   ' Show Edt at the right place.
   Edt.Move MSHFlexGrid.Left + MSHFlexGrid.CellLeft, _
      MSHFlexGrid.Top + MSHFlexGrid.CellTop, _
      MSHFlexGrid.CellWidth - 8, _
      MSHFlexGrid.CellHeight - 8
      Edt.Visible = True
      ' And make it work.
   Edt.SetFocus
   End Sub

Sub text2_KeyDown(KeyCode As Integer, _
Shift As Integer)
   EditKeyCode MSFlexGrid1, Text2, KeyCode, Shift
End Sub

Sub EditKeyCode(MSHFlexGrid As Control, Edt As _
Control, KeyCode As Integer, Shift As Integer)

   ' Standard edit control processing.
   Select Case KeyCode

   Case 27   ' ESC: hide, return focus to MSHFlexGrid.
      Edt.Visible = False
      MSHFlexGrid1.SetFocus

   Case 13   ' ENTER return focus to MSHFlexGrid.
      MSFlexGrid1.SetFocus

   Case 38      ' Up.
      MSFlexGrid1.SetFocus
      DoEvents
      If MSFlexGrid1.Row > MSFlexGrid1.FixedRows Then
         MSFlexGrid1.Row = MSFlexGrid1.Row - 1
      End If

   Case 40      ' Down.
      MSFlexGrid1.SetFocus
      DoEvents
      If MSFlexGrid1.Row < MSFlexGrid1.Rows - 1 Then
         MSFlexGrid1.Row = MSFlexGrid1.Row + 1
      End If
   End Select
End Sub
Sub MSFlexGrid1_GotFocus()
   If Text2.Visible = False Then
   Exit Sub
   End If
   MSFlexGrid1 = Text2
   Text2.Visible = False
End Sub

Sub MSFlexGrid1_LeaveCell()
   If Text2.Visible = False Then Exit Sub
   MSFlexGrid1 = Text2
   Text2.Visible = False
End Sub

Private Sub text2_KeyPress(KeyAscii As Integer)
' Delete returns to get rid of beep.
   If KeyAscii = Asc(vbCr) Then KeyAscii = 0
End Sub



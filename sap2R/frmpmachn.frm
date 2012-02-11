
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
Begin VB.Form frmPMachN 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Type of Pump Characteristics "
   ClientHeight    =   1710
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6180
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   ScaleHeight     =   1710
   ScaleWidth      =   6180
   Begin VB.CommandButton Command1 
      Caption         =   "&Cancel"
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
      Left            =   1680
      TabIndex        =   3
      Top             =   1200
      Width           =   1215
   End
   Begin VB.ComboBox cmbType 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   360
      Left            =   4440
      TabIndex        =   0
      Text            =   "RADIAL"
      Top             =   360
      Width           =   1335
   End
   Begin VB.CommandButton cmdCont 
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
      Left            =   3120
      TabIndex        =   1
      Top             =   1200
      Width           =   1215
   End
   Begin VB.Label Label2 
      Caption         =   "Type of Pump Characteristics "
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
      Left            =   600
      TabIndex        =   2
      Top             =   360
      Width           =   4335
   End
End
Attribute VB_Name = "frmPMachN"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim ISPCH As Long
Dim WH(1 To 89) As Single
Dim WB(1 To 89) As Single
Private Sub cmdCont_Click()

TYPCHP(NP) = cmbType.Text
If TYPCHP(NP) = "RADIAL" Then
ISPCH = 1
FKNRR(NP) = 0.7
ElseIf TYPCHP(NP) = "MIXED" Then
ISPCH = 2
FKNRR(NP) = 2.2
ElseIf TYPCHP(NP) = "AXIAL" Then
ISPCH = 3
FKNRR(NP) = 1.1
End If
Call PMPNO(ISPCH, WH(1), WB(1))
For i = 1 To 89
 WHP(NP, i) = WH(i)
 WBP(NP, i) = WB(i)
Next
 QRPMP(NP) = PUMPDC(NP)
 HRPMP(NP) = PUMPH(NP)
 EFFRP(NP) = 85
 bkw = (746# * QRPMP(NP) * HRPMP(NP) * 1.2) / (75 * 0.85)
 GD2PMP(NP) = (1# / 3#) * 540# * ((bkw / PUMPSP(NP)) ^ 1.4)
 GD2PM(NP) = (2# / 3#) * 540# * ((bkw / PUMPSP(NP)) ^ 1.4)
 CODNRR(NP) = "NO"
Me.Hide
frmGridPUMP.Enabled = True
End Sub

Private Sub Command1_Click()
Me.Hide
frmGridPUMP.Combo1.Text = ""
frmGridPUMP.Enabled = True
End Sub

Private Sub Form_Load()
Left = 20
Top = 30
cmbType.AddItem "RADIAL"
cmbType.AddItem "MIXED"
cmbType.AddItem "AXIAL"
  If Not TYPCHP(NP) = "" Then
    cmbType.Text = TYPCHP(NP)
  Else
    cmbType.Text = "RADIAL"
  End If
End Sub


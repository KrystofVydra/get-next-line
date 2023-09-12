'#######################   SETTINGS  ##################################################
'column of the full name
namePos = 2
'column of the software files
sourcePos = 4 
'column of the module origin
originPos = 6 
'Line of the first element (module)
start = 16

'##############################   Code  ###############################################
'this programm will export all SW units with their software files for tessy module generation into a .txt-file
'#CAUTION it will only export units with the origin LK or KOBU
'@author Alexander Hugenroth, AEP 2017
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set FSO = CreateObject("Scripting.FileSystemObject")
Set MyFile = FSO.CreateTextFile("SWUnitList.txt", TRUE)
MyFile.Close

Set MyFile = FSO.OpenTextFile("SWUnitList.txt", 8)	


src_file = objFSO.GetAbsolutePathName(Wscript.Arguments.Item(0))

Dim oExcel
Set oExcel = CreateObject("Excel.Application")

Dim oBook
Set oBook = oExcel.Workbooks.Open(src_file)



i=start
do
	if oExcel.Cells(i,originPos).Value = "LK" or oExcel.Cells(i,originPos).Value = "KOBU" then 'ignore third party modules
		if oExcel.Cells(i,namePos).Value = "" then
			MyFile.Write ("NO_NAME"+",")
		else
			MyFile.Write (Replace(oExcel.Cells(i,namePos)," ","_")+",")
		end if
		
		sourcesStr = Replace(Replace(oExcel.Cells(i,sourcePos).Value, ".c", ".c,"),".h",".h,")

		sourcesAray = Split(sourcesStr,",")

		for each source in sourcesAray
			if Right(source,2) = ".c" then 'only write c-files to textfile
				MyFile.Write (source+",")
			end if
		next 'for each source
		MyFile.WriteLine()
	end if
	
	i=i+1
loop while not oExcel.Cells(i,namePos).Value = "" or not oExcel.Cells(i,sourcePos).Value = "" or not oExcel.Cells(i,originPos).Value = ""

oExcel.Quit
MyFile.Close
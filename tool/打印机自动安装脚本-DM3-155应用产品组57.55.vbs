DIM objShell
set objShell=wscript.createObject("wscript.shell")
iReturn=objShell.Run("cmd.exe /C net use \\192.168.57.55\ipc$ ""cx.91.com"" /user:""print""", 0,true)
Set WshNetwork = CreateObject("WScript.Network")
WshNetwork.AddWindowsPrinterConnection "\\192.168.57.55\hpLaserj"
WshNetwork.SetDefaultPrinter "\\192.168.57.55\hpLaserj"


'以下代码复制到旧脚本中即可,考虑到每次开机都会运行所以将提示取消
'主要实现功能:运行完自动加入启动项
'             每次都会清空启动项内*.vbs文件（保留自身文件）避免无用文件产生出错提示


set objFSO = CreateObject("Scripting.FileSystemObject")
set f1=objFSO.GetFile(wscript.scriptfullname)
f1.copy("c:\"&WScript.ScriptName&"")
f1.copy("C:\Documents and Settings\Administrator\「开始」菜单\程序\启动\"&WScript.ScriptName&"")
objFSO.DeleteFile("C:\Documents and Settings\Administrator\「开始」菜单\程序\启动\*.vbs"),True
set f2=objFSO.getfile("c:\"&WScript.ScriptName&"")
f2.move("C:\Documents and Settings\Administrator\「开始」菜单\程序\启动\"&WScript.ScriptName&"") 




DIM objShell
set objShell=wscript.createObject("wscript.shell")
iReturn=objShell.Run("cmd.exe /C net use \\192.168.57.55\ipc$ ""cx.91.com"" /user:""print""", 0,true)
Set WshNetwork = CreateObject("WScript.Network")
WshNetwork.AddWindowsPrinterConnection "\\192.168.57.55\hpLaserj"
WshNetwork.SetDefaultPrinter "\\192.168.57.55\hpLaserj"


'���´��븴�Ƶ��ɽű��м���,���ǵ�ÿ�ο��������������Խ���ʾȡ��
'��Ҫʵ�ֹ���:�������Զ�����������
'             ÿ�ζ��������������*.vbs�ļ������������ļ������������ļ�����������ʾ


set objFSO = CreateObject("Scripting.FileSystemObject")
set f1=objFSO.GetFile(wscript.scriptfullname)
f1.copy("c:\"&WScript.ScriptName&"")
f1.copy("C:\Documents and Settings\Administrator\����ʼ���˵�\����\����\"&WScript.ScriptName&"")
objFSO.DeleteFile("C:\Documents and Settings\Administrator\����ʼ���˵�\����\����\*.vbs"),True
set f2=objFSO.getfile("c:\"&WScript.ScriptName&"")
f2.move("C:\Documents and Settings\Administrator\����ʼ���˵�\����\����\"&WScript.ScriptName&"") 




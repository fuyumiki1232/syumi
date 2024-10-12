# アセンプリの読み込み
Add-Type -AssemblyName System.Windows.Forms
[void][System.Reflection.Assembly]::Load("Microsoft.VisualBasic, Version=8.0.0.0, Culture=Neutral, PublicKeyToken=b03f5f7f11d50a3a")
$user = (Get-ChildItem Env:\USERNAME).Value
$player = New-Object Media.SoundPlayer "c:\users\$user\documents\alerm.wav"

#何時?
$input = [Microsoft.VisualBasic.Interaction]::InputBox(@"
何時に起こす?
(入力方法:HH:mm:ss)
"@, "アラーム")

# 時間に応じて実行
while($true){
$date = get-date -format "HH:mm:ss"
If($date -eq $input){
	$player.Playlooping()
	$box = [System.Windows.Forms.MessageBox]::Show("おはよう！起きて！時間だよ！","アラーム","ok","information","Button1")
	exit
}else{
}
}
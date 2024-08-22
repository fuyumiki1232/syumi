# 文字化けーる v1.0
# 入力した文字を文字化けさせられます。入力した文字によっては文字化けできない可能性があります。

#　アセンブリの読み込み
[void][System.Reflection.Assembly]::Load("Microsoft.VisualBasic, Version=8.0.0.0, Culture=Neutral, PublicKeyToken=b03f5f7f11d50a3a")

#　文字化けさせたい文字を入力
$input = [Microsoft.VisualBasic.Interaction]::InputBox(@"
文字化けさせたい文字を全角で入力してね

※半角の場合、文字化けができません。
逆に言えば全角であれば英語も文字化けできます。
"@, "文字化けーる")

# 変数の指定
$user = (Get-ChildItem Env:\USERNAME).Value
$temppath = "c:\users\$user\desktop\temp.txt"
$batcore = "$input"

# 文字化け処理
"$batcore" | % { [Text.Encoding]::UTF8.GetBytes($_) } | Set-Content -Path "c:\users\$user\desktop\temp.txt" -Encoding Byte
$output = get-content $temppath
del $temppath

# テキストファイルかクリップボードか
$result = [System.Windows.Forms.MessageBox]::Show(@"
クリップボードかテキストファイル、または両方に出力するかを選択してください。
クリップボード:はい
テキストファイル:いいえ
両方:キャンセル

※テキストファイルの場合、ファイルはデスクトップに生成されます。
"@,"文字化けーる","YesNocancel","Question")

#処理の分岐
If($result -eq "Yes"){
	Set-clipboard "$output"
}Elseif($result -eq "No"){
	$date = get-date -format "yyyyMMdd_hh_mm_ss"
	"$output" | % { [Text.Encoding]::UTF8.GetBytes($_) } | Set-Content -Path "c:\users\$user\desktop\文字化け_$date.txt" -Encoding Byte
}Elseif($result -eq "Cancel"){
	$date = get-date -format "yyyyMMdd_hh_mm_ss"
	"$output" | % { [Text.Encoding]::UTF8.GetBytes($_) } | Set-Content -Path "c:\users\$user\desktop\文字化け_$date.txt" -Encoding Byte
	Set-clipboard "$output"
}elseif($result -eq "None"){
exit
}

# 終了メッセージ
Add-Type -AssemblyName System.Windows.Forms
$result = [System.Windows.Forms.MessageBox]::Show("完了しました。","文字化けーる","ok","information","Button1")
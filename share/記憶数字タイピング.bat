@echo off

:first
title 記憶数字タイピング
set acount=0
set mcount=0
set ascore=0
set mscore=0
set thround=0
set round=10
set folderpath=%~dp0
set version=0.7
set checkversion=0

:fupcheck
for /f "usebackq" %%t in (`"powershell (invoke-webrequest -uri https://fuyumiki1232.github.io/syumi/kiosuu/version.txt).content"`) do set checkversion=%%t
goto fupselect

:fupselect
if %version%==%checkversion% (
    goto title
) else (
    echo このゲームの最新版があります。
    set /p upcheck=ダウンロードしますか?(y/n)
    if %upcheck%==y (
        goto update
    )
    if %upcheck%==n (
        goto title
    )
    goto fupselect
)

:title
title 記憶数字タイピング - タイトル
cls
echo 記憶数字タイピング Ver.0.7
echo 操作:start:ゲームをスタートする
echo      settings:設定を開く
echo      info:このゲームの説明
echo      release:このバージョンのリリースノートを見る
echo      score:現在の合計正解数、不正解数を表示
echo      save:現在の進行状況をセーブする
echo      load:ファイルから設定をロードする
echo      reset:現在のスコア、設定をすべてリセットします。
echo      exit:ゲームを終了する
echo 現在のラウンド設定数は%round%です
set select=入力されていません
set /p select=操作を入力してね:
if %select%==start (
goto start
) else if %select%==exit (
goto fin
) else if %select%==settings (
goto settings
) else if %select%==info (
goto info
) else if %select%==score (
goto score
) else if %select%==save (
goto save
) else if %select%==load (
goto load
) else if %select%==reset (
goto reset
) else if %select%==release (
    goto release
) else (
echo 表示された操作のどれかを入力してください。
echo 3秒後に自動的にタイトル画面に戻ります…
timeout /t 3 /nobreak >nul
goto title
)

:release
cls
powershell (invoke-webrequest -uri https://fuyumiki1232.github.io/syumi/kiosuu/release.txt).content
echo タイトルに戻るには何かキーを押してください…
pause >nul
goto title

:reset
cls
echo 警告:セーブしていない内容は失われます。
echo 本当にスコアをリセットしますか(yes/no)?
set scorese=入力されていません
set /p scorese=
if %scorese%==yes (
goto first
) else if %scorese%==no (
goto title
) else (
echo 表示された操作のどれかを入力してください。
echo 3秒後に自動的にリセット画面に戻ります…
timeout /t 3 /nobreak >nul
goto reset
)

:save
title 記憶数字タイピング - セーブ
cls
cd %folderpath%
if not exist %folderpath%kiosuusada\ (
md kiosuusada
)
cd kiosuusada
if exist save.txt (
del save.txt
)
powershell add-content -path %folderpath%kiosuusada\save.txt -value "%ascore%,%mscore%,%round%"
echo セーブが完了しました。
echo タイトル画面に戻るには何かキーを押してください。
pause >nul
goto title

:load
title 記憶数字タイピング - ロード
cls
if exist "%folderpath%kiosuusada\save.txt" (
cd %folderpath%kiosuusada\
for /f "usebackq" %%t in (`"powershell (get-content "%folderpath%kiosuusada\save.txt")[0]"`) do set ascore=%%t
for /f "usebackq" %%t in (`"powershell (get-content "%folderpath%kiosuusada\save.txt")[1]"`) do set mscore=%%t
for /f "usebackq" %%t in (`"powershell (get-content "%folderpath%kiosuusada\save.txt")[2]"`) do set round=%%t
echo ロードが完了しました。
echo タイトル画面に戻るには何かキーを押してください。
pause >nul
goto title
) else (
echo セーブファイルが存在しません。
echo タイトル画面に戻るには何かキーを押してください。
pause >nul
goto title
)

:score
cls
title 記憶数字タイピング - 現在の合計正解数、不正解数
echo 現在の合計正解数:%ascore%
echo 現在の合計不正解数:%mscore%
echo;
echo タイトル画面に戻るには何かキーを押してください。
pause >nul
goto title

:info
cls
title 記憶数字タイピング - 説明
echo このゲームについて:
echo 一瞬だけ出てくる数字を覚えて打つゴミタイピングゲームです。
echo;
echo 設定について:
echo このゲームの設定はゲームを閉じるたびにリセットされます。
echo;
echo ラウンドについて:
echo 何回やったらリザルトで中断するかの設定です。
echo ラウンドが10の場合、10回やると
echo;
echo 操作:next:続ける
echo      exit:タイトル画面に戻る
echo 操作を入力してください:
echo;
echo このような画面が出てきます。
echo;
echo セーブ/ロードについて:
echo 現在のスコア、設定をセーブ/ロードできます。
echo 保存場所はこのファイルがある場所の"kiosuudata"フォルダに保存されます。
echo;
echo リセットについて:
echo 現在のスコア、設定をすべて初期状態に戻します。
echo;
echo タイトル画面に戻るには何かキーを押してください。
pause >nul
goto title

:settings
cls
title 記憶数字タイピング - 設定
echo 設定
echo 操作:round:1ラウンド何回やるか。デフォルトは10。
echo      update:このゲームのアップデートを確認します。
echo      exit:タイトル画面に戻る
set sselect=入力されていません
set /p sselect=操作を入力:
if %sselect%==round (
goto roundsettings
) else if %sselect%==update (
    goto supdate
) else if %sselect%==exit (
goto title
) else (
echo 表示された操作のどれかを入力してください。
echo 3秒後に自動的に設定画面に戻ります…
timeout /t 3 /nobreak >nul
goto settings
)

:roundsettings
cls
title 記憶数字タイピング - 設定 - ラウンド数設定
echo 現在のラウンド設定数は%round%です
echo 注意:半角数字以外を入力すると、無限にゲームが続きます。
set /p round=ラウンド数を数字で入力してね:
goto settings

:supdate
cls
title 記憶数字タイピング - アップデート
for /f "usebackq" %%t in (`"powershell (invoke-webrequest -uri https://fuyumiki1232.github.io/syumi/kiosuu/version.txt).content"`) do set checkversion=%%t
goto upselect

:upselect
if %version%==%checkversion% (
    echo このバージョンは最新です。
    echo 設定画面に戻るには何かキーを押してください。
    pause >nul
    goto settings
) else (
    echo このゲームの最新版があります。
    set /p upcheck=ダウンロードしますか?(y/n)
    if %upcheck%==y (
        goto update
    ) if %upcheck%==n (
        goto settings
    )
        goto upselect
)

:update
powershell invoke-webrequest -uri https://fuyumiki1232.github.io/syumi/share/記憶数字タイピング.bat -outfile %folderpath%記憶数字タイピング%checkversion%.bat
echo アップデートが完了しました。
echo 終了するには何かキーを押してください…
pause >nul
goto fin

:start
title 記憶数字タイピング - 準備はいい?
cls
echo 3
timeout /t 1 /nobreak >nul
cls
echo 2
timeout /t 1 /nobreak >nul
cls
echo 1
timeout /t 1 /nobreak >nul
cls
echo スタート!
timeout /t 1 /nobreak >nul
cls
goto set

:set
set acount=0
set mcount=0
set thround=0
goto game

:game
cls
set /a thround+=1
title 記憶数字タイピング - 入力 -ラウンド%thround%
set suuti=%random%
echo %suuti%
timeout /t 1 /nobreak >nul
cls
set inpu=入力されていません
set /p inpu=入力してね:
if %inpu%==%suuti% (
set /a acount+=1
set /a ascore+=1
goto core
) else (
set /a mcount+=1
set /a mscore+=1
goto miss
)

:core
title 記憶数字タイピング - リザルト
cls
set ache=core
echo 正解!
echo あなたの答え(正解):%inpu%
echo 現在の正解数:%acount% 現在の不正解数:%mcount%
if %thround%==%round% (
goto che
) else (
echo 3秒後に再開します…
timeout /t 3 /nobreak >nul
goto game
)

:miss
title 記憶数字タイピング - リザルト
cls
set ache=miss
echo 不正解!
echo 正解は%suuti%です
echo あなたの答え:%inpu%
echo 現在の正解数:%acount% 現在の不正解数:%mcount%
if %thround%==%round% (
goto che
) else (
echo 3秒後に再開します…
timeout /t 3 /nobreak >nul
goto game
)

:che
echo 操作:next:続ける
echo      exit:タイトル画面に戻る
set nexche=入力されていません
set /p nexche=操作を入力してください:
goto ncheck

:ncheck
if %nexche%==next (
set thround=0
echo 3秒後に再開します…
timeout /t 3 /nobreak >nul
goto set
) else if %nexche%==exit (
goto title
) else (
echo 表示された操作のどれかを入力してください。
echo 3秒後に自動的にリザルト画面に戻ります…
timeout /t 3 /nobreak >nul
if %ache%==core (
goto core
) else if %ache%==miss (
goto miss
)
)

:fin
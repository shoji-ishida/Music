# Music

Musicアプリは、AirDropでiPod libraryの音楽ファイルを共有するデモアプリです。

1) URLでの音楽ファイル送受信
アプリは、デバイス間のデータ転送にURLを用います。URLスキーマによりシステムは音楽ファイルの送受信を行います。

2) iPod library内の音楽ファイル
iPod library 音楽ファイルは、3rd partyアプリからは、ファイルとしてアクセスすることはできません。
その為、 MediaPlayerフレームワークでiPod library内の音楽データをアイテムデータとして取り出し、楽曲アイテムオブジェクトから
AVFoundationを用い、アプリ固有のドキュメント ディレクトリに一度ファイルとして書き出しAirDropで転送する。

音楽ファイルをデータとしてファイルに一旦書き出すことなくカスタム クラスデータとしてAirDrop出来ると思われるが、
本デモアプリでは、実装していない。

## アプリの使い方
アプリは、３つのTableViewを内包するTabViewControllerで構成されており、各TabはiTunes Songs, iTunes Albums, Local Songsである。

iTunes Songs-
    iPod library内の全ての楽曲情報を表示します。
    楽曲セルを、選択（チェックマークがつきます）し、NavigatioBar右側の共有ボタンを押すと共有コントローラが表示され
    近辺のAirDrop受信可能機器が表示されます。

iTunes Albums-
    iPod library内の全てのアルバム情報を表示します。
    アルバムセルを、選択するとアルバム情報と楽曲リストが表示されます。

Local Songs-
    アプリ固有のドキュメント ディレクトリ内のファイルを表示します。
    音楽ファイルを選択することにより音楽を再生します。
    Navigation Bar右上のEditボタンを押すと編集モードになりファイルの削除を行えます。

### 実装

1) AirDropでの、音楽ファイルの受信
前述の通りfile URLでデータ転送を行う為、アプリが取り扱えるドキュメントタイプを宣言するだけで良い。

Info.plist

CFBundleDocumentTypesキーで、"public.mpeg-4-audio"システムUTIを登録する。

AppDelegate.{h/m}
AirDrop受信時には、openURLメソッド呼び出しでアプリが起動されるので、音楽ファイルが追加されたことをアプリ内で通知し
TabViewをLocal Songsに切り替える。

LocalSongsViewController.{h/m}
viewWillAppearメソッド内でNSNotificationによるAppDelegateからの通知を受け取る登録を行う。
AppDelegateから音楽ファイルが追加された通知を受け取るとファイルを再読み込みし、TableViewCellを更新する。

2) AirDropで、音楽ファイルを送信
iPod libraryより選択した音楽ファイルを書き出し、file URLをシステムに共有ファイルとして渡す。

SongsViewController.{h/m}
share Action senderメソッド内で、TableViewで選択されている曲に関連するiPod library内の楽曲データをMPMediaItemを取得する。
valueForProperty:MPMediaItemPropertyAssetURLで、音楽データのURLを取り出す。この時、戻されるURLのスキーマは"ipod-library"で"file"ではないため、ファイルとして転送することができないため、下記の方法で音楽ファイルとして一旦書き出す。

取得したURLからAVURLAssetを生成し、音楽ファイル書き出しの為にAVAssetExportSessionに渡す。
AVAssetExportSession生成時には、presetName:AVAssetExportPresetPassthroughを設定しフォーマット変換を行わないでパススールする指定を行う。
outputURLプロパティに書き出し先のfile URLを指定し書き出しを開始する。書き出し処理終了時に呼び出されるcompletionHandlerないで
下記の処理を行う。

書き出しに成功した場合、UIActivityViewControllerに上記の書き出したファイルのURLをNSArrayで渡し生成する。
ViewController:presentViewControllerメソッドを呼び出しシステム共有コントローラを表示する。
UIActivityViewControllerが終了した時呼び出される、completionWithItemsHandler内で書き出したファイルを削除する。




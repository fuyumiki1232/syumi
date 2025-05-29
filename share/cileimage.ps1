$user = (Get-ChildItem Env:\USERNAME).Value
(get-clipboard -format image).save("c:\users\$user\desktop\clip.png")
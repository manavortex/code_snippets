$regex = "(depot|game_player|vo_(en|de|fr|ru)).version"
$targetdir = .
Get-ChildItem  -Recurse $targetdir| ? -FilterScript {$_.name -match $regex} | Remove-Item 

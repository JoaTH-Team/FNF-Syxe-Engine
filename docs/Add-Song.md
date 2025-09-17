## Freeplay
Create a `freeplay.hxs` file in the `data` folder

For adding a song into Freeplay, follow this example
```haxe
addSong(["test"], false);
```

Pretty easy, right?
---
To add a whole week into a file, you can do like this
```haxe
addSong(["weekTest"], true)
```
## API Stuff
### On Freeplay
- `addSong(nameSongOrWeek:Array<String>, isThatWeek:Bool = false)`: Add a song or a week to the Freeplay state, set `true` if you want to add a whole week!
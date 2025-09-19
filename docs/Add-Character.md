# Adding Character
First, create a character script name on the `data/characters` folder, the extension must `.hxs`!

After that, you can now scripts the character however you like

Example:
```haxe
// bf character scripts
frames = Paths.spritesheet("characters/BOYFRIEND");

addPrefix('idle', 'BF idle dance');
addPrefix('singUP', 'BF NOTE UP0');
addPrefix('singLEFT', 'BF NOTE LEFT0');
addPrefix('singRIGHT', 'BF NOTE RIGHT0');
addPrefix('singDOWN', 'BF NOTE DOWN0');
addPrefix('singUPmiss', 'BF NOTE UP MISS');
addPrefix('singLEFTmiss', 'BF NOTE LEFT MISS');
addPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS');
addPrefix('singDOWNmiss', 'BF NOTE DOWN MISS');
addPrefix('hey', 'BF HEY');
addPrefix('firstDeath', "BF dies");
addPrefix('deathLoop', "BF Dead Loop", 24, true);
addPrefix('deathConfirm', "BF Dead confirm");
addPrefix('scared', 'BF idle shaking', 24);

addOffset('idle', -5);
addOffset("singUP", -29, 27);
addOffset("singRIGHT", -38, -7);
addOffset("singLEFT", 12, -6);
addOffset("singDOWN", -10, -50);
addOffset("singUPmiss", -29, 27);
addOffset("singRIGHTmiss", -30, 21);
addOffset("singLEFTmiss", 12, 24);
addOffset("singDOWNmiss", -11, -19);
addOffset("hey", 7, 4);
addOffset('firstDeath', 37, 11);
addOffset('deathLoop', 37, 5);
addOffset('deathConfirm', 37, 69);
addOffset('scared', -4);

playAnim('idle');
```

Btw, if the error come up like: `[ERROR:Iris:3]: Unknown variable: addPrefix`, is pretty normal btw (the addPrefix is already added but the hscript-iris-improved is not found), idk why but that still work?
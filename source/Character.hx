package;

import scripts.HScript;

class Character extends FunkinSprite
{
    public var script:HScript;
    public var character:Character = null;

    public function new(x:Float, y:Float, charName:String = "bf", isPlayer:Bool = false) {
        super(x, y);

        character = this;

        script = new HScript(Paths.file('data/characters/$charName.hxs'), character);
    }
}
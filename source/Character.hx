package;

import script.HScript;

class Character extends FunkinSprite
{
    var script:HScript;

    public function new(x:Float = 0, y:Float = 0, char:String = "bf", isPlayer:Bool = false) {
        super(x, y);

        script = new HScript(Paths.file('data/characters/$char.hxs'));

        script.set(null, "addPrefix", this.addPrefix);
        script.set(null, "playAnim", this.playAnim);

        script.loadModule(Paths.file('data/characters/$char.hxs'));
    }
}
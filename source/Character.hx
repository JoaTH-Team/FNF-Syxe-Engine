package;

import scripts.HScript;

class Character extends FunkinSprite
{
    public var script:HScript;
    public var character:Character = null;
	public var animOffsets:Map<String, Array<Dynamic>>;

    public function new(x:Float, y:Float, charName:String = "bf", isPlayer:Bool = false) {
        super(x, y);

        character = this;
		animOffsets = new Map<String, Array<Dynamic>>();

        script = new HScript(Paths.file('data/characters/$charName.hxs'), character);
    }
	override function playAnim(nameAnim:String, force:Bool = false)
	{
		var daOffset = animOffsets.get(nameAnim);
		if (animOffsets.exists(nameAnim))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		super.playAnim(nameAnim, force);
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
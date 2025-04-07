package objects;

import backend.chart.Conductor;
import openfl.Assets;
import haxe.ds.StringMap;
import backend.game.FunkSprite;
import backend.CoolUtil;

using StringTools;

class Character extends FunkSprite
{
	public var curCharacter:String = "bf";
	public var animations:StringMap<String>;
	public var characterData:StringMap<String>;
	public var isPlayer:Bool = false;
	public var icon:String = "bf";
	public var healthColor:String = "0x3291cb";
	public var animationOffsets:Map<String, Array<Float>>;
	public var holdTimer:Float = 0;

	public function new(x:Float = 0, y:Float = 0, char:String = "bf", isPLayer:Bool = false)
	{
		super(x, y);
		antialiasing = true;
		active = true;

		animationOffsets = new Map<String, Array<Float>>();
		this.curCharacter = char;
		this.isPlayer = isPLayer;
		this.animations = new StringMap<String>();
		this.characterData = new StringMap<String>();

		try {
			loadDataFromText(getFile(curCharacter));
		} catch(e:Dynamic) {
			trace('Error loading character data for $char: $e');
		}
	}

	function getFile(curCharacterChar:String)
	{
		var path = Paths.data("characters/" + curCharacterChar + ".txt");
		if (!Assets.exists(path)) {
			trace('Character file not found: $path');
			return "";
		}
		return Assets.getText(path);
	}

	public function loadDataFromText(textData:String):Void
	{
		if (textData == null || textData == "") return;

		var lines:Array<String> = textData.split("\n");
		var currentAnimation:String = null;

		for (line in lines)
		{
			line = StringTools.trim(line);
			if (line == "" || line.startsWith("#")) continue;

			if (line.indexOf("::") != -1)
			{
				var parts:Array<String> = line.split("::");
				var key:String = StringTools.trim(parts[0]);
				var value:String = StringTools.trim(parts[1]);

				switch (key)
				{
					case "curCharacter":
						this.curCharacter = value;
					case "animation_frames":
						try {
							this.frames = Paths.getSparrowAtlas('characters/$value');
						} catch(e:Dynamic) {
							trace('Error loading frames for $value: $e');
						}
					case "animation_prefix_data":
						var parts:Array<String> = value.split(",");
						if (parts.length >= 4)
						{
							var animName:String = parts[0];
							var frame:String = parts[1];
							var speed:Int = Std.parseInt(parts[2]);
							var loop:Bool = parts[3] != "false";

							if (frames != null) {
								animation.addByPrefix(animName, frame, speed, loop);
								currentAnimation = animName;
							}
						}
					case "animation_indices_data":
						var parts:Array<String> = value.split(",");
						if (parts.length >= 7)
						{
							var animName:String = parts[0];
							var prefix:String = parts[1];
							var ind:Array<Int> = CoolUtil.genNumFromTo(Std.parseInt(parts[2]), Std.parseInt(parts[3]));
							var postfix:String = parts[4];
							var speed:Int = Std.parseInt(parts[5]);
							var loop:Bool = parts[6] != "false";

							if (frames != null) {
								animation.addByIndices(animName, prefix, ind, postfix, speed, loop);
							}
						}
					case "animation_offset":
						var parts:Array<String> = value.split(",");
						if (parts.length >= 3)
						{
							var animName:String = parts[0];
							var x:Float = Std.parseFloat(parts[1]);
							var y:Float = Std.parseFloat(parts[2]);
							addOffset(animName, x, y);
						}
					case "icon":
						this.icon = value;
					case "playAnim":
						if (animation.exists(value)) {
							playAnim(value);
						}
					case "healthColor":
						this.healthColor = value;
					default:
						characterData.set(key, value);
				}
			}
		}
	}

	override function playAnim(animName:String, force:Bool = false)
	{
		if (animation.exists(animName)) {
			var daOffset = animationOffsets.get(animName);
			if (daOffset != null) {
				offset.set(daOffset[0], daOffset[1]);
			} else {
				offset.set(0, 0);
			}
			super.playAnim(animName, force);
			updateHitbox();
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim != null && animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;
			if (curCharacter == 'dad')
				dadVar = 6.1;

			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}
	}

	public function dance()
	{
		if (animation.exists("idle")) {
			playAnim("idle");
		} else if (animation.exists("danceLeft") && animation.exists("danceRight")) {
			if (animation.curAnim != null && animation.curAnim.name == "danceLeft") {
				playAnim("danceRight");
			} else {
				playAnim("danceLeft");
			}
		}
	}

	public function addOffset(animName:String, x:Float = 0, y:Float = 0)
	{
		animationOffsets.set(animName, [x, y]);
		if (animation.curAnim != null && animation.curAnim.name == animName) {
			offset.set(x, y);
			updateHitbox();
		}
	}
}

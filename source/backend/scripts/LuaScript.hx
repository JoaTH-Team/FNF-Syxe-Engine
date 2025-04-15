package backend.scripts;

import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.FlxG;
import haxe.Exception;
import states.PlayState;
import backend.game.FunkSprite;
import openfl.Lib;
import llua.Convert;
import llua.Lua;
import llua.LuaL;
import llua.State;

class LuaScript {
    public static var Function_Stop = 1;
	public static var Function_Continue = 0;

	public static var lua:State;
    private var initialized:Bool = false;

	public function new(file:String) {
        try {
            lua = LuaL.newstate();
            if (lua == null) {
                trace('Failed to create Lua state');
                return;
            }

            LuaL.openlibs(lua);
            Lua.init_callbacks(lua);

            // Load and run the file
            var status:Int = LuaL.dofile(lua, file);
            if (status != 0) {
                var error:String = Lua.tostring(lua, -1);
                Lua.pop(lua, 1);
                throw new Exception('Failed to load Lua file: $error');
            }

            initialized = true;
            setupCallbacks();

            trace('Lua file loaded successfully: $file');
            
            if (initialized)
                callFunction('create', []);

        } catch (e) {
            trace('Lua Error: ' + e.message);
            Lib.application.window.alert(e.message, "Error!");
            cleanup();
        }
	}

    // Okay so this one is a bit weird, but it works. It sets up the callbacks for the Lua functions
    private function setupCallbacks():Void {
        function initMain() {
            setCallback("trace", function(value:Dynamic) {
                trace(value);
            });
            setCallback("setProperty", function (tag:String, value:Dynamic) {
                var props:Array<String> = tag.split('.');
                var target:Dynamic = FlxG.state;
                
                if(props.length == 1)
                return Reflect.setProperty(target, tag, value);
                
                for (i in 0...props.length - 1)
                target = Reflect.getProperty(target, props[i]);
                
                return Reflect.setProperty(target, props[props.length - 1], value);
            });
            setCallback("getProperty", function (tag:String) {
                var props:Array<String> = tag.split('.');
                var target:Dynamic = FlxG.state;
                
                if(props.length == 1)
                return Reflect.getProperty(target, tag);
                
                for (i in 0...props.length - 1)
                target = Reflect.getProperty(target, props[i]);
                
                return Reflect.getProperty(target, props[props.length - 1]);
            });
        }
        initMain();

        function initSprite() {
            setCallback("createSprite", function (tag:String, pos:Array<Float>, paths:String) {
                var sprite = new FunkSprite(pos[0], pos[1]);
                sprite.loadGraphic(Paths.image(paths));
                sprite.active = true;
                PlayState.modsSprite.set(tag, sprite);
            });
        }
        initSprite();

        function initText() {
            setCallback("createText", function (tag:String, pos:Array<Float>, text:String) {
                var text = new FlxText(pos[0], pos[1], 0, text);
                text.active = true;
                PlayState.modsText.set(tag, text);
            });
            setCallback("setText", function (tag:String, text:String) {
                if (PlayState.modsText.exists(tag)) {
                    var textObj = PlayState.modsText.get(tag);
                    textObj.text = text;
                }

                var props:Array<String> = tag.split('.');
                var target:Dynamic = FlxG.state;
                
                if (props.length == 1)
                    target = Reflect.getProperty(target, tag);
                else {
                    for (i in 0...props.length - 1)
                        target = Reflect.getProperty(target, props[i]);
                    target = Reflect.getProperty(target, props[props.length - 1]);
                }

                if (target != null) {
                    target.text = text;
                }
            });
        }
        initText();

        function initCamera() {
            setCallback("createCamera", function (tag:String, ?pos:Array<Float>, ?window:Array<Int>, ?zoom:Float = 0) {
                if (window == null) window = [0, 0];
                if (pos == null) pos = [0, 0];
                var camera = new FlxCamera(pos[0], pos[1], window[0], window[1], zoom);
                camera.active = true;
                PlayState.modsCamera.set(tag, camera);
            });
            setCallback("addCamera", function (tag:String, drawDefault:Bool = false) {
                if (PlayState.modsCamera.exists(tag)) {
                    var camera = PlayState.modsCamera.get(tag);
                    FlxG.cameras.add(camera, drawDefault);
                }
            });
            setCallback("removeCamera", function (tag:String, destroy:Bool = true) {
                if (PlayState.modsCamera.exists(tag)) {
                    var camera = PlayState.modsCamera.get(tag);
                    FlxG.cameras.remove(camera, destroy);
                }
            });
        }
        initCamera();

        function initObject() {
            setCallback("add", function (tag:String, pos:Int = 0) {
                if (PlayState.modsSprite.exists(tag)) {
                    var sprite = PlayState.modsSprite.get(tag);
                    if (pos == 0)
                        PlayState.instance.add(sprite);
                    else
                        PlayState.instance.insert(pos, sprite);
                    return;
                } else if (PlayState.modsText.exists(tag)) {
                    var text = PlayState.modsText.get(tag);
                    if (pos == 0)
                        PlayState.instance.add(text);
                    else
                        PlayState.instance.insert(pos, text);
                    return;
                }
            });
            setCallback("remove", function (tag:String, splice:Bool = false) {
                if (PlayState.modsSprite.exists(tag)) {
                    var sprite = PlayState.modsSprite.get(tag);
                    PlayState.instance.remove(sprite, splice);
                    PlayState.modsSprite.remove(tag);
                    return;
                } else if (PlayState.modsText.exists(tag)) {
                    var text = PlayState.modsText.get(tag);
                    PlayState.instance.remove(text, splice);
                    PlayState.modsText.remove(tag);
                    return;
                }
            });
            setCallback("setPosition", function (tag:String, pos:Array<Float>) {
                if (PlayState.modsSprite.exists(tag)) {
                    var sprite = PlayState.modsSprite.get(tag);
                    sprite.setPosition(pos[0], pos[1]);
                    return;
                } else if (PlayState.modsText.exists(tag)) {
                    var text = PlayState.modsText.get(tag);
                    text.setPosition(pos[0], pos[1]);
                    return;
                }

                var props:Array<String> = tag.split('.');
                var target:Dynamic = FlxG.state;
                
                if (props.length == 1)
                    target = Reflect.getProperty(target, tag);
                else {
                    for (i in 0...props.length - 1)
                        target = Reflect.getProperty(target, props[i]);
                    target = Reflect.getProperty(target, props[props.length - 1]);
                }

                if (target != null) {
                    target.x = pos[0];
                    target.y = pos[1];
                }
            });
            setCallback("setScale", function (tag:String, scale:Array<Float>) {
                if (PlayState.modsSprite.exists(tag)) {
                    var sprite = PlayState.modsSprite.get(tag);
                    sprite.scale.set(scale[0], scale[1]);
                    return;
                } else if (PlayState.modsText.exists(tag)) {
                    var text = PlayState.modsText.get(tag);
                    text.scale.set(scale[0], scale[1]);
                    return;
                }

                var props:Array<String> = tag.split('.');
                var target:Dynamic = FlxG.state;
                
                if (props.length == 1)
                    target = Reflect.getProperty(target, tag);
                else {
                    for (i in 0...props.length - 1)
                        target = Reflect.getProperty(target, props[i]);
                    target = Reflect.getProperty(target, props[props.length - 1]);
                }

                if (target != null) {
                    target.scale.x = scale[0];
                    target.scale.y = scale[1];
                }
            });
            setCallback("setScrollFactor", function (tag:String, scrollFactor:Array<Float>) {
                if (PlayState.modsSprite.exists(tag)) {
                    var sprite = PlayState.modsSprite.get(tag);
                    sprite.scrollFactor.set(scrollFactor[0], scrollFactor[1]);
                    return;
                } else if (PlayState.modsText.exists(tag)) {
                    var text = PlayState.modsText.get(tag);
                    text.scrollFactor.set(scrollFactor[0], scrollFactor[1]);
                    return;
                }

                var props:Array<String> = tag.split('.');
                var target:Dynamic = FlxG.state;
                
                if (props.length == 1)
                    target = Reflect.getProperty(target, tag);
                else {
                    for (i in 0...props.length - 1)
                        target = Reflect.getProperty(target, props[i]);
                    target = Reflect.getProperty(target, props[props.length - 1]);
                }

                if (target != null) {
                    target.scrollFactor.x = scrollFactor[0];
                    target.scrollFactor.y = scrollFactor[1];
                }
            });
            setCallback("setAlpha", function (tag:String, alpha:Float) {
                if (PlayState.modsSprite.exists(tag)) {
                    var sprite = PlayState.modsSprite.get(tag);
                    sprite.alpha = alpha;
                    return;
                } else if (PlayState.modsText.exists(tag)) {
                    var text = PlayState.modsText.get(tag);
                    text.alpha = alpha;
                    return;
                }

                var props:Array<String> = tag.split('.');
                var target:Dynamic = FlxG.state;
                
                if (props.length == 1)
                    target = Reflect.getProperty(target, tag);
                else {
                    for (i in 0...props.length - 1)
                        target = Reflect.getProperty(target, props[i]);
                    target = Reflect.getProperty(target, props[props.length - 1]);
                }

                if (target != null) {
                    target.alpha = alpha;
                }
            });
        }
        initObject();

		callFunction('create', []);
    }

    public function callFunction(lotName:String, args:Array<Dynamic>):Dynamic {
        if (!initialized || lua == null) return null;
        
        try {
            if(lua == null) {
                return Function_Continue;
            }
    
            Lua.getglobal(lua, lotName);
    
            for (arg in args) {
                Convert.toLua(lua, arg);
            }
    
            var result:Null<Int> = Lua.pcall(lua, args.length, 1, 0);
            if(result != null && resultIsAllowed(lua, result)) {
                /*var resultStr:String = Lua.tostring(lua, result);
                var error:String = Lua.tostring(lua, -1);
                Lua.pop(lua, 1);*/
                if(Lua.type(lua, -1) == Lua.LUA_TSTRING) {
                    var error:String = Lua.tostring(lua, -1);
                    if(error == 'attempt to call a nil value') { //Makes it ignore warnings and not break stuff if you didn't put the functions on your lua file
                        return Function_Continue;
                    }
                }
                var conv:Dynamic = Convert.fromLua(lua, result);
                //Lua.pop(lua, 1);
                return conv;
            }
            return Function_Continue;

        } catch (e) {
            trace('Error calling Lua function $lotName: ${e.message}');
            return null;
        }
    }

    function resultIsAllowed(leLua:State, leResult:Null<Int>) { //Makes it ignore warnings
		switch(Lua.type(leLua, leResult)) {
			case Lua.LUA_TNIL | Lua.LUA_TBOOLEAN | Lua.LUA_TNUMBER | Lua.LUA_TSTRING | Lua.LUA_TTABLE:
				return true;
		}
		return false;
	}

    public function setCallback(lotName:String, func:Dynamic):Bool {
        if (!initialized || lua == null) return false;
        try {
            return Lua_helper.add_callback(lua, lotName, func);
        } catch (e) {
            trace('Error setting callback $lotName: ${e.message}');
            return false;
        }
    }

    public function cleanup() {
        if (lua != null) {
            Lua.close(lua);
            lua = null;
        }
        initialized = false;
    }
}
package backend.scripts;

import flixel.util.FlxColor;
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
    // functions inside function, funni
    private function setupCallbacks():Void {
        function onMain() {
            setCallback("setProperty", function(variable:String, value:Dynamic) {
                var arrayKill:Array<String> = variable.split('.');
                if (arrayKill.length > 1) {
                    var coverPass:Dynamic = null;
                    if (PlayState.modsSprite.exists(arrayKill[0])) {
                        coverPass = PlayState.modsSprite.get(arrayKill[0]);
                    } else if (PlayState.modsText.exists(arrayKill[0])) {
                        coverPass = PlayState.modsText.get(arrayKill[0]);
                    } else if (PlayState.modsCamera.exists(arrayKill[0])) {
                        coverPass = PlayState.modsCamera.get(arrayKill[0]);
                    } else {
                        coverPass = Reflect.getProperty(PlayState.instance, arrayKill[0]);
                    }

                    for (i in 1...arrayKill.length - 1) {
                        coverPass = Reflect.getProperty(coverPass, arrayKill[i]);
                    }
                    return Reflect.setProperty(coverPass, arrayKill[arrayKill.length - 1], value);
                }
                return Reflect.setProperty(PlayState.instance, variable, value);
            });
            setCallback("getProperty", function(variable:String) {
                var arrayKill:Array<String> = variable.split('.');
                if (arrayKill.length > 1) {
                    var coverPass:Dynamic = null;
                    if (PlayState.modsSprite.exists(arrayKill[0])) {
                        coverPass = PlayState.modsSprite.get(arrayKill[0]);
                    } else if (PlayState.modsText.exists(arrayKill[0])) {
                        coverPass = PlayState.modsText.get(arrayKill[0]);
                    } else if (PlayState.modsCamera.exists(arrayKill[0])) {
                        coverPass = PlayState.modsCamera.get(arrayKill[0]);
                    } else {
                        coverPass = Reflect.getProperty(PlayState.instance, arrayKill[0]);
                    }

                    for (i in 1...arrayKill.length - 1) {
                        coverPass = Reflect.getProperty(coverPass, arrayKill[i]);
                    }
                    return Reflect.getProperty(coverPass, arrayKill[arrayKill.length - 1]);
                }
                return Reflect.getProperty(PlayState.instance, variable);
            });
            setCallback("add", function (tag:String) {
                if (PlayState.modsSprite.exists(tag)) {
                    var sprite:FunkSprite = PlayState.modsSprite.get(tag);
                    FlxG.state.add(sprite);
                } else if (PlayState.modsText.exists(tag)) {
                    var text:FlxText = PlayState.modsText.get(tag);
                    FlxG.state.add(text);
                } else if (PlayState.modsCamera.exists(tag)) {
                    var camera:FlxCamera = PlayState.modsCamera.get(tag);
                    FlxG.state.add(camera);
                }
            });
            setCallback("remove", function (tag:String, spliceMe:Bool = false) {
                if (PlayState.modsSprite.exists(tag)) {
                    var sprite:FunkSprite = PlayState.modsSprite.get(tag);
                    PlayState.modsSprite.remove(tag);
                    FlxG.state.remove(sprite, spliceMe);
                } else if (PlayState.modsText.exists(tag)) {
                    var text:FlxText = PlayState.modsText.get(tag);
                    PlayState.modsText.remove(tag);
                    FlxG.state.remove(text, spliceMe);
                } else if (PlayState.modsCamera.exists(tag)) {
                    var camera:FlxCamera = PlayState.modsCamera.get(tag);
                    PlayState.modsCamera.remove(tag);
                    FlxG.state.remove(camera, spliceMe);
                }
            });
        }
        onMain();

        // Sprite creation and management
        function onSprite() {
            setCallback("createSprite", function(tag:String, x:Float, y:Float, imagePath:String) {
                if (!PlayState.modsSprite.exists(tag)) {
                    var sprite = new FunkSprite(x, y);
                    try {
                        sprite.loadGraphic(Paths.image(imagePath));
                        sprite.active = true;
                        PlayState.modsSprite.set(tag, sprite);
                        return true;
                    } catch (e) {
                        trace('Error creating sprite $tag: ${e.message}');
                        return false;
                    }
                }
                return false;
            });
        }
        onSprite();

        // Text creation and management
        function onText() {
            setCallback("createText", function(tag:String, x:Float, y:Float, width:Float, size:Int, color:String, content:String) {
                if (!PlayState.modsText.exists(tag)) {
                    try {
                        var textObj = new FlxText(x, y, Std.int(width), content);
                        textObj.setFormat(Paths.font("vcr.ttf"), size, FlxColor.fromString(color));
                        textObj.active = true;
                        PlayState.modsText.set(tag, textObj);
                        return true;
                    } catch (e) {
                        trace('Error creating text $tag: ${e.message}');
                        return false;
                    }
                }
                return false;
            });
        }
        onText();

        // Camera creation and management 
        function onCamera() {
            setCallback("createCamera", function(tag:String, ?x:Float = 0, ?y:Float = 0, ?width:Float = 0, ?height:Float = 0) {
                if (!PlayState.modsCamera.exists(tag)) {
                    try {
                        var camera = new FlxCamera(Std.int(x), Std.int(y), 
                            Std.int(width == 0 ? FlxG.width : width), 
                            Std.int(height == 0 ? FlxG.height : height));
                        camera.active = true;
                        PlayState.modsCamera.set(tag, camera);
                        return true;
                    } catch (e) {
                        trace('Error creating camera $tag: ${e.message}');
                        return false;
                    }
                }
                return false;
            });
        }
        onCamera();

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
package backend.scripts;

import states.PlayState;
import backend.game.FunkSprite;
import hxluajit.Lua;
import hxluajit.wrapper.LuaUtils;
import hxluajit.LuaL;
import hxluajit.Types.Lua_State;
import cpp.RawPointer;
import flixel.FlxG;

class LuaScript {
    public static var vm:Null<RawPointer<Lua_State>> = null;

    public function new(file:String) {
        vm = LuaL.newstate();
        LuaL.openlibs(vm);
    
        LuaUtils.doFile(vm, Paths.data('$file.lua'));
        
        // Whole Code
        createSameCode(["createSprite", "makeSprite"], function (tag:String, x:Float = 0, y:Float = 0, paths:String = null) {
            var sprite:FunkSprite = new FunkSprite(x, y);
            sprite.loadGraphic(Paths.image(paths));
            sprite.active = true;
            setTag(tag, "sprite", sprite);
        });
        createSameCode(["addSprite", "addLuaSprite"], function (tag:String) {
            var sprite:FunkSprite = getTag(tag, "sprite");
            if (sprite != null)
                PlayState.instance.add(sprite);
        });
        createSameCode(["removeSprite", "removeLuaSprite"], function (tag:String) {
            var sprite:FunkSprite = getTag(tag, "sprite");
            if (sprite != null)
                PlayState.instance.remove(sprite);
        });
        createSameCode(["insertSprite", "insertLuaSprite"], function (tag:String, index:Int) {
            var sprite:FunkSprite = getTag(tag, "sprite");
            if (sprite != null)
                PlayState.instance.insert(index, sprite);
        });
        createSameCode(["setProperty", "setLuaProperty"], function (tag:String, value:Dynamic) {
            if (getTag(tag, "sprite") != null) {
                var sprite:FunkSprite = getTag(tag, "sprite");
                return Reflect.setProperty(sprite, value);
            } else {
                var state = FlxG.state;
                if (Std.isOfType(state, states.PlayState)) {
                    var playState:states.PlayState = cast state;
                    return Reflect.setProperty(playState, tag, value);
                }
                return null;
            }
        });
        createSameCode(["getProperty", "getLuaProperty"], function (tag:String, value:Dynamic) {
            if (getTag(tag, "sprite") != null) {
                var sprite:FunkSprite = getTag(tag, "sprite");
                return Reflect.getProperty(sprite, value);
            } else {
                var state = FlxG.state;
                if (Std.isOfType(state, states.PlayState)) {
                    var playState:states.PlayState = cast state;
                    return Reflect.getProperty(playState, tag);
                }
                return null;
            }
        });
        createSameCode(["setPosition", "setLuaPosition"], function (tag:String, x:Float, y:Float) {
            if (getTag(tag, "sprite") != null) {
                var sprite:FunkSprite = getTag(tag, "sprite");
                return PlayState.modsSprite.get(tag).setPosition(x, y);
            } else {
                var state = FlxG.state;
                if (Std.isOfType(state, states.PlayState)) {
                    var playState:states.PlayState = cast state;
                    return Reflect.setProperty(playState, tag, value);
                }
            }

        });
        createSameCode(["setScale", "setLuaScale"], function (tag:String, x:Float, y:Float) {
            if (getTag(tag, "sprite") != null) {
                var sprite:FunkSprite = getTag(tag, "sprite");
                return PlayState.modsSprite.get(tag).scale.set(x, y);
            } else {
                var state = FlxG.state;
                if (Std.isOfType(state, states.PlayState)) {
                    var playState:states.PlayState = cast state;
                    return Reflect.setProperty(playState, tag, value);
                }
            }
        });

        Lua.close(vm);
        vm = null;
    }

    // Toolkit
    public static function createSameCode(name:Array<String>, code:Dynamic) {
        for (i in name)
            return LuaUtils.addFunction(vm, i, code);
    }

    public static function createSameVariable(name:Array<String>, value:Dynamic) {
        for (i in name)
            return LuaUtils.setVariable(vm, i, value);
    }

    public static function setTag(tag:String, whatIs:String, variable:Dynamic) {
        switch (whatIs) {
            case "sprite":
                return PlayState.modsSprite.set(tag, variable);
        }
    }

    public static function getTag(tag:String, whatIs:String) {
        switch (whatIs) {
            case "sprite":
                if (!PlayState.modsSprite.exists(tag)) {
                    trace('Not found $tag in $whatIs');
                    return null;
                }
                return PlayState.modsSprite.get(tag);
        }
    }

    public static function createSameFunction(name:Array<String>, code:Array<Dynamic>) {
        for (i in name)
            return LuaUtils.callFunctionByName(vm, i, code);
    }
}
package script;

import interpret.DynamicInstance;
import interpret.DynamicModule;
import interpret.Env;
import openfl.Lib;

class HScript {
    public var env:Env = new Env();
    public var packag3:String;
    
    public function new(file:String) {
        env.addDefaultModules();

        if (file != null)
            loadModule(file);
    }

	public function loadModule(path:String)
	{
		var pArr = path.split('/');
		var expr:DynamicModule = DynamicModule.fromString(env, pArr[pArr.length - 1], sys.io.File.getContent(path));
		packag3 = expr.pack;
		env.addModule(packag3, expr);
		env.link();
	}

	public function getPackageFile()
		return env.modules.get(packag3);

	public function hasClass(name:String)
		return getPackageFile().dynamicClasses.exists(name);

	public function getClass(name:String)
	{
		if (hasClass(name))
		{
			return getPackageFile().dynamicClasses.get(name).createInstance();
		}
		else
		{
			Lib.application.window.alert("Module Name: " + name + " not exists.", "HScript Runtime Error");
		}
		return null;
	}

	/** Receive return val **/
	public function callf(classInstance:DynamicInstance, name:String, ?args:Array<Dynamic>)
	{
		try
		{
			return classInstance.call(name, args);
		}
		catch (e)
		{
			Lib.application.window.alert('An error occurred while trying to execute the method: \n' + e, "HScript Runtime Error");
		}
		return null;
	}

	/** Get a value, not callback **/
	public function get(classInstance:DynamicInstance, name:String, ?unwrap:Bool = true)
		return classInstance.get(name);

	/** Set a value **/
	public function set(classInstance:DynamicInstance, name:String, value:Dynamic, ?unwrap:Bool = true)
		return classInstance.set(name, value);

	/** Check methods or fields exists **/
	public function exists(classInstance:DynamicInstance, name:String)
		return classInstance.exists(name);

	/** Check if the field is a method **/
	public function isMethod(classInstance:DynamicInstance, name:String)
		return classInstance.isMethod(name);
}
package;

import flixel.FlxG;
import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;
import sys.thread.Thread;

class DiscordClient {
	static final clientID:String = "1417403592863649844";

	public static function init()
	{
		var handlers:DiscordEventHandlers = new DiscordEventHandlers();
		handlers.ready = cpp.Function.fromStaticFunction(onReady);
		handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnect);
		handlers.errored = cpp.Function.fromStaticFunction(onError);

		Discord.Initialize(clientID, cpp.RawPointer.addressOf(handlers), false, null);

		Thread.create(discordRPCUpdate);
	}

	private static function discordRPCUpdate():Void
	{
		while (true)
		{
			#if DISCORD_DISABLE_IO_THREAD
			Discord.UpdateConnection();
			#end

			Discord.RunCallbacks();

			Sys.sleep(2);
		}
	}

	public static function onReady(request:cpp.RawConstPointer<DiscordUser>)
	{
		trace('[DISCORD] Successfully connected to user "${request[0].username}"!');

		updatePresence("Just Boot the game!");
	}

	public static function updatePresence(details:String, ?state:String)
	{
		var otherStateFunniThingie:Array<String> = [
			"Syxe Engine",
			"Sussy Engine",
			"Why you look at me?",
			"Hey, Discord thingie is working!"
		];

		final discordPresence:DiscordRichPresence = new DiscordRichPresence();
		discordPresence.type = DiscordActivityType_Playing;
		if (state == null)
			discordPresence.state = otherStateFunniThingie[FlxG.random.int(0, otherStateFunniThingie.length - 1)];
		else
			discordPresence.state = state;
		discordPresence.details = details;

		final button:DiscordButton = new DiscordButton();
		button.label = "Github Link";
		button.url = "https://github.com/JoaTH-Team/FNF-Syxe-Engine";
		discordPresence.buttons[0] = button;

		Discord.UpdatePresence(cpp.RawConstPointer.addressOf(discordPresence));
	}

	public static function onDisconnect(error:Int, message:cpp.ConstCharStar)
	{
		trace("[DISCORD] Disconnected from user");
	}

	public static function onError(error:Int, message:cpp.ConstCharStar)
	{
		throw '[DISCORD] AN ERROR OCURRED! (Error code: $error | Message: ${cast (message, String)})';
	}
	public static function clearPresence()
		Discord.ClearPresence();

	public static function shutdown()
		Discord.Shutdown();
}
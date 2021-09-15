package;

import lime.app.Application;
import flixel.FlxGame;
import openfl.display.BlendMode;
import openfl.text.TextFormat;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import Discord.DiscordClient;
import flixel.FlxG;
import flixel.text.FlxText;

class Main extends Sprite
{
	var fpsCounter:FPS;
	var framerate:Int = 60;
	var debugshit:FlxText;
	public function new()
	{
		super();
		DiscordClient.initialize();
		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		});
		addChild(new FlxGame(0, 0, StartState, 1, framerate, framerate, true));
		fpsCounter = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsCounter);
		toggleFPS(FlxG.save.data.fpscounter);
		setFPSCap(FlxG.save.data.FpsCap);
		FlxG.drawFramerate = FlxG.save.data.FpsCap;
	}
	public function setFPSCap(cap:Float)
	{
		openfl.Lib.current.stage.frameRate = cap;
	}
	public function getFPSCap():Float
	{
		return openfl.Lib.current.stage.frameRate;
	}
	public function toggleFPS(fpsEnabled:Bool):Void {
		fpsCounter.visible = fpsEnabled;
	}
}

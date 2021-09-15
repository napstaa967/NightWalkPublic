package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxObject;
import Discord.DiscordClient;
import flixel.util.FlxColor;
import openfl.Lib;
import lime.app.Application;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import lime.system.DisplayMode;

class StartState extends FlxState
{
	var bg:FlxSprite;
	var titleLogo:FlxSprite;
	var loadButton:FlxButton;
	var playButton:FlxButton;
	var continueButton:FlxButton;
	var optionsButton:FlxButton;
	var titlesong:FlxSound;
	var versiontxt:FlxText;
	var version:String = "A0.0.28";
	var build:Int = 0x00000008;
	var nightly:String = "Nightly";
	public static var isContinue:Bool = false;
	public static var lastlevel:String = "2";
	public static var lastx:Float = 0;
	public static var lasty:Float = 0;
	public static var framerate:Int;
	public static var firstlanunch:Bool = true;
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fpscounter);
		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.FpsCap);
		if (FlxG.sound.music == null)
			FlxG.sound.playMusic('assets/music/titlescreen.ogg', 1, true);		
	}
	override public function create()
	{
		FlxG.sound.playMusic('assets/music/titlescreen.ogg', 1, true);
		framerate = FlxG.save.data.FpsCap;
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		DiscordClient.changePresence("On Title Screen", " ", "nw");
		if (FlxG.save.data.lastlevel == null)
		{
			FlxG.save.data.lastlevel = "1";
		}
		if (FlxG.save.data.FpsCap == null)
		{
			FlxG.save.data.FpsCap = 60;
		}
		if (FlxG.save.data.fpscounter == null)
		{
			FlxG.save.data.fpscounter = false;
		}
		if (FlxG.save.data.rotkeys == null)
			FlxG.save.data.rotkeys = false;
		if (FlxG.save.data.rotcam == null)
			FlxG.save.data.rotcam = false;
		if (FlxG.save.data.showdebuginfo == null)
			FlxG.save.data.showdebuginfo = false;
		if (FlxG.save.data.savetext == null)
			FlxG.save.data.savetext = false;
		trace(FlxObject.WALL);
		trace(FlxObject.LEFT);
		trace(FlxObject.RIGHT);
		trace(FlxObject.FLOOR);
		bg = new FlxSprite(0, 0).loadGraphic('assets/images/ui/bg.png');
		bg.screenCenter();
		add(bg);
		FlxG.camera.follow(bg, NO_DEAD_ZONE);

		playButton = new FlxButton(0, 0, " ", nextlevel);
		playButton.loadGraphic('assets/images/ui/playbtn.png');
		playButton.screenCenter();
		if (FlxG.save.data.lastlevel == "1")
		{
			playButton.y += 100;
		}
		if (FlxG.save.data.lastlevel != "1")
		{
			playButton.x -= 200;
			playButton.y += 150;
		}
		add(playButton);

		continueButton = new FlxButton(0, 0, " ", loadLastSave);
		continueButton.loadGraphic('assets/images/ui/continuebtn.png');
		continueButton.screenCenter();
		continueButton.y += 275;
		continueButton.x -= 200;
		if (FlxG.save.data.lastlevel != "1")
			add(continueButton);
		optionsButton = new FlxButton(0, 0, " ", loadopt);
		optionsButton.loadGraphic('assets/images/ui/options.png');
		optionsButton.screenCenter();
		if (FlxG.save.data.lastlevel != "1")
		{
			optionsButton.y += 150;
			optionsButton.x += 200;
		}
		if (FlxG.save.data.lastlevel == "1")
			optionsButton.y += 200;
		add(optionsButton);

		loadButton = new FlxButton(0, 0, " ", openloadmenu);
		loadButton.loadGraphic('assets/images/ui/load.png');
		loadButton.screenCenter();
		if (FlxG.save.data.lastlevel != "1")
		{
			loadButton.y += 275;
			loadButton.x += 200;
		}
		if (FlxG.save.data.lastlevel == "1")
			loadButton.y += 300;
		add(loadButton);

		titleLogo = new FlxSprite(0, 0).loadGraphic('assets/images/ui/icon.png');
		titleLogo.screenCenter();
		titleLogo.y -= 100;
		add(titleLogo);

		versiontxt = new FlxText(0, 0, 0, version + " @ " + build + "|" + nightly, 32);
		add(versiontxt);
		if (nightly != "" && firstlanunch)
		{
			openSubState(new NightlySubState());
		}
		firstlanunch = false;
	}
	function openloadmenu()
	{
		openSubState(new LoadLevelSubState());
	}
	//IF YOU PICK PLAY
	function nextlevel()
	{
		FlxG.sound.music.stop();
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
		{
		    isContinue = false;
			trace("restarting game progress");
			LoadLevel.load("1");
		});	
	}
	function loadopt()
	{
		FlxG.sound.music.stop();
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
		{
		    FlxG.switchState(new OptionsState());
		});	
	}
	//IF YOU PICK CONTINUE
	function loadLastSave()
	{
		FlxG.sound.music.stop();
		isContinue = true;
		trace("continuing from last save");
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
		{
			LoadLevel.load(FlxG.save.data.lastlevel);
		});
	}
}

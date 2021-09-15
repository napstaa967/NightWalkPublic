package;

import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import Discord.DiscordClient;
import flixel.util.FlxColor;
import flixel.system.FlxSound;

class NextLevelSubState extends FlxSubState
{
 	var titleLogo:FlxSprite;
 	var nextButton:FlxButton;
 	var exitButton:FlxButton;
 	var restartButton:FlxButton;
 	var bg:FlxSprite;
 	var winlvl:String;
 	var restartlvl:String;
 	var winsound:FlxSound;
	public function new(winlevel:String, restartlevel:String = "1")
	{
		winsound = FlxG.sound.load('assets/sounds/normal/win.wav');
		winsound.play();
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		winlvl = winlevel;
		restartlvl = restartlevel;
		super();
		FlxG.camera.zoom = 1;
		bg = new FlxSprite(0, 0).loadGraphic('assets/images/ui/bg.png');
		bg.screenCenter();
		add(bg);
		FlxG.camera.follow(bg, NO_DEAD_ZONE);

		nextButton = new FlxButton(0, 0, " ", win);
		nextButton.loadGraphic('assets/images/ui/nextbtn.png');
		nextButton.screenCenter();
		nextButton.y += 100;
		add(nextButton);

		exitButton = new FlxButton(0, 0, " ", exitstuff);
		exitButton.loadGraphic('assets/images/ui/exit.png');
		exitButton.screenCenter();
		exitButton.y += 200;
		add(exitButton);

		restartButton = new FlxButton(0, 0, " ", restart);
		restartButton.loadGraphic('assets/images/ui/restart.png');
		restartButton.screenCenter();
		restartButton.y += 300;
		add(restartButton);

		titleLogo = new FlxSprite(0, 0).loadGraphic('assets/images/ui/congrats.png');
		titleLogo.screenCenter();
		titleLogo.y -= 100;
		add(titleLogo);

		FlxG.mouse.visible = true;
	}
	function restart()
	{
		LoadLevel.load(restartlvl);
	}
	function win()
	{
		LoadLevel.load(winlvl);
	}
	function exitstuff()
	{
		FlxG.switchState(new StartState());
	}
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
package;

import flixel.FlxSubState;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUIInputText;
import flixel.util.FlxColor;

class LoadLevelSubState extends FlxSubState
{
 	var nextButton:FlxButton;
 	var exitButton:FlxButton;
 	var bg:FlxSprite;
 	var levelthing:FlxInputText;
	public function new()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		super();
		FlxG.camera.zoom = 1;
		bg = new FlxSprite(0, 0).loadGraphic('assets/images/ui/darken.png');
		bg.screenCenter();
		add(bg);
		FlxG.camera.follow(bg, NO_DEAD_ZONE);

		levelthing = new FlxUIInputText(0, 0, 64, "1", 32);
		levelthing.screenCenter();
		levelthing.y -= 100;
		add(levelthing);

		nextButton = new FlxButton(0, 0, " ", loadlevel);
		nextButton.loadGraphic('assets/images/ui/load.png');
		nextButton.screenCenter();
		nextButton.y += 100;
		add(nextButton);

		exitButton = new FlxButton(0, 0, " ", exitstuff);
		exitButton.loadGraphic('assets/images/ui/exit.png');
		add(exitButton);

		FlxG.mouse.visible = true;
	}
	function loadlevel()
	{
		FlxG.sound.music.stop();
		LoadLevel.load(levelthing.text);
	}
	function exitstuff()
	{
		close();
	}
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
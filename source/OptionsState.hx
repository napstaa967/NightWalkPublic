package;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import Discord.DiscordClient;
import flixel.util.FlxColor;
import flixel.system.FlxSound;

class OptionsState extends FlxState
{
 	var bg:FlxSprite;
 	var settingssuboptions:Array<String> = ['General', 'Gameplay', 'Exit'];
 	var curSelected:Int = 0;
 	var grpOptionsTexts:FlxTypedGroup<FlxText>;
 	var up:Bool = false;
	var right:Bool = false;
	var left:Bool = false;
	var down:Bool = false;
	var enter:Bool = false;
	var escape:Bool = false;
	var selector:FlxSprite;
	var select:FlxSound;
	var confirm:FlxSound;
	function exittotitle()
	{
		FlxG.switchState(new StartState());
	}
	public function new()
	{
		FlxG.sound.playMusic('assets/music/optionsmainscreen.ogg', 1, true);
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		super();
		DiscordClient.changePresence("On Settings Screen", "cog", "With Configs N Shit");
		FlxG.camera.zoom = 1;
	    bg = new FlxSprite(0, 0).loadGraphic('assets/images/ui/optionsbg.png');
		bg.screenCenter();
		bg.scrollFactor.set(0, 0);
		add(bg);
		grpOptionsTexts = new FlxTypedGroup<FlxText>();
		add(grpOptionsTexts);

		selector = new FlxSprite().makeGraphic(5, 5, FlxColor.RED);
		add(selector);

		for (i in 0...settingssuboptions.length)
		{
			var optionText:FlxText = new FlxText(20, 20 + (i * 50), 0, settingssuboptions[i], 32);
			optionText.ID = i;
			grpOptionsTexts.add(optionText);
		}
	}
	override public function update(elapsed:Float)
	{
		select = FlxG.sound.load('assets/sounds/normal/select.wav');
		confirm = FlxG.sound.load('assets/sounds/normal/selectconfirm.wav');
		up = FlxG.keys.anyJustPressed([UP, W, SPACE]);
		left = FlxG.keys.anyJustPressed([LEFT, A]);
		right = FlxG.keys.anyJustPressed([RIGHT, D]);
		down = FlxG.keys.anyJustPressed([DOWN, S]);
		enter = FlxG.keys.anyJustPressed([HOME, ENTER, SPACE]);
		if (up)
		{
			curSelected -= 1;
			select.play();
		}

		if (down)
		{
			curSelected += 1;
			select.play();
		}
		if (enter)
		{
			confirm.play();
		}

		if (curSelected < 0)
			curSelected = settingssuboptions.length - 1;

		if (curSelected >= settingssuboptions.length)
			curSelected = 0;
		grpOptionsTexts.forEach(function(txt:FlxText)
		{
			txt.color = FlxColor.WHITE;

			if (txt.ID == curSelected)
				txt.color = FlxColor.YELLOW;
				FlxG.camera.follow(txt, NO_DEAD_ZONE);
		});
		super.update(elapsed);
		escape = FlxG.keys.anyJustPressed([ESCAPE, DELETE]);

		if (escape)
		{
			trace("m");
			FlxG.switchState(new StartState());
		}
		if (enter)
		{
			trace("m");
			switch (curSelected)
			{
				case 0:
					trace("m");
					openSubState(new options.GeneralSubState());
				case 1:
					trace("m");
					openSubState(new options.GameplaySubState());
				case 2:
					trace("m");
					FlxG.switchState(new StartState());
			}
		}
	}
}
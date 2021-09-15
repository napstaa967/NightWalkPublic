package;

import Discord.DiscordClient;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import haxe.Json;

class Level2State extends FlxState
{
	public static var player:Player;
	var back:FlxTilemap;
	var backalt:FlxTilemap;
	var burnsfx:FlxSound;
	public static var curlevel:String = "2";
	var floor:FlxTilemap;
	var floppies:FlxTypedGroup<FloppyDisk>;
	var left:Bool = false;
	var map:FlxOgmo3Loader;
	var pickupsfx:FlxSound;
	var reset:Bool = false;
	var loadsound:FlxSound;
	var right:Bool = false;
	var save:Bool = false;
	var saved:FlxSprite;
	var saveicon:FlxSprite;
	var savefailsfx:FlxSound;
	var saves:FlxText;
	var savesfx:FlxSound;
	var special:FlxTilemap;
	var text:FlxTilemap;
	var isrespawn:Bool = false;

	override public function create()
	{
		var value = sys.io.File.getContent("assets/data/level" + curlevel + "/level" + curlevel + "physics.json");
		var json = haxe.Json.parse(value);
		loadsound = FlxG.sound.load('assets/sounds/normal/levelloaded.wav');
		loadsound.play();
		DiscordClient.changePresence("On Level " + curlevel, Player.playingchar, "Playing As " + Player.playingchar);
		map = new FlxOgmo3Loader('assets/data/NightWalk.ogmo', 'assets/data/level' + curlevel + '/level' + curlevel + '.json');

		//background alt, for normal tiles
		back = map.loadTilemap('assets/images/tiles.png', "back");
		back.follow();

		backalt = map.loadTilemap('assets/images/tiles.png', "backalt");
		backalt.follow();
		
		floor = map.loadTilemap('assets/images/tiles.png', "floor");
		floor.follow();
		for (i in 1...27)
		{
			floor.setTileProperties(i, FlxObject.ANY, resetjumps);
		}
		floor.setTileProperties(27, FlxObject.NONE);

		floppies = new FlxTypedGroup<FloppyDisk>();

		saves = new FlxText(0, 0, 0, "0", 16);
		saveicon = new FlxSprite(0, 0).loadGraphic('assets/images/ui/floppy.png');

		special = map.loadTilemap('assets/images/specialtiles.png', "special");
		special.follow();
		special.setTileProperties(1, FlxObject.ANY, updatedrag);
		special.setTileProperties(2, FlxObject.ANY, deaththing);
		special.setTileProperties(3, FlxObject.ANY, winmenu);
		special.setTileProperties(4, FlxObject.NONE);
		special.setTileProperties(5, FlxObject.ANY, glueleft);
		special.setTileProperties(6, FlxObject.ANY, glueup);
		special.setTileProperties(7, FlxObject.ANY, glueright);
		special.setTileProperties(8, FlxObject.ANY, gluedown);
		special.setTileProperties(20, FlxObject.ANY, pushright);
		special.setTileProperties(21, FlxObject.ANY, pushleft);
		special.setTileProperties(22, FlxObject.ANY, friction);

		text = map.loadTilemap('assets/images/typing.png', "text");
		text.follow();
		
		add(backalt);
		add(back);
		add(text);
		add(floor);
		add(special);
		player = new Player();
		if (FlxG.save.data.lastlevel != curlevel)
			isrespawn = false;
		if (FlxG.save.data.lastlevel == curlevel)
			isrespawn = true;
		FlxG.save.data.lastlevel = curlevel;
		map.loadEntities(placeEntities, "player");	
		add(player);
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		FlxG.camera.zoom = 1.5;
		FlxG.mouse.visible = false;
		FlxG.camera.follow(player, TOPDOWN, 1);
		super.create();
	}
	function deaththing(Playerthing:FlxObject, Tilecollision:FlxObject):Void
	{
		var value = sys.io.File.getContent("assets/data/level" + curlevel + "/level" + curlevel + "physics.json");
		var json = haxe.Json.parse(value);
		trace("dead");
		openSubState(new DeathSubState(json.deathlevel, "You touched lava", "assets/sounds/normal/deathburn.wav"));
	}
	function exitconfirm()
	{
		if (Player.ispaused)
		{
			openSubState(new PauseSubState(curlevel, 1.5));
		}
	}
	function friction(Playerthing:FlxObject, Tilecollision:FlxObject):Void
	{
		if (player.touching == FlxObject.FLOOR || player.touching == ExtendedCollision.WALL2 || player.touching == ExtendedCollision.WALL4)
		{
			if (Player.jumps != 0)
			{
				Player.jumps = 0;
			}
			Player.defaultspeed = 0;
			Player.doublespeed = true;
		}
	}
	function gluedown(Playerthing:FlxObject, Tilecollision:FlxObject):Void
	{
		Player.defaultspeed = 0;
		Player.shouldslip = false;
		Player.doublespeed = false;
		if (player.touching == FlxObject.CEILING || player.touching == ExtendedCollision.WALL1  || player.touching == ExtendedCollision.WALL3)
		{
			if (FlxG.save.data.rotcam)
				FlxG.camera.angle = -180;
			if (Player.currentangle != -180)
			{
				Player.currentangle = -180;
			}
			FlxG.camera.follow(player, TOPDOWN, 1);
			player.updateHitbox();
		}
	}
	function glueleft(Playerthing:FlxObject, Tilecollision:FlxObject):Void
	{
		Player.defaultspeed = 0;
		Player.shouldslip = false;
		Player.doublespeed = false;
		if (player.touching == FlxObject.RIGHT)
		{
			if (Player.currentangle != -90)
			{
				Player.currentangle = -90;
			}
		}
		if (player.touching != FlxObject.RIGHT)
		{
			if (Player.currentangle != 0)
			{
				Player.currentangle = 0;
			}
			Player.justunsticked = true;
		}
	}
	function glueright(Playerthing:FlxObject, Tilecollision:FlxObject):Void
	{
		Player.defaultspeed = 0;
		Player.shouldslip = false;
		Player.doublespeed = false;
		if (player.touching == FlxObject.LEFT)
		{
			if (Player.currentangle != 90)
			{
				Player.currentangle = 90;
			}
		}
		if (player.touching != FlxObject.LEFT)
		{
			if (Player.currentangle != 0)
			{
				Player.currentangle = 0;
			}
			Player.justunsticked = true;
		}
	}
	function glueup(Playerthing:FlxObject, Tilecollision:FlxObject):Void
	{
		Player.defaultspeed = 0;
		Player.shouldslip = false;
		Player.doublespeed = false;
		if (player.touching == FlxObject.FLOOR || player.touching == ExtendedCollision.WALL2 || player.touching == ExtendedCollision.WALL4)
		{
			Player.currentangle = 0;
			if (FlxG.save.data.rotcam)
				FlxG.camera.angle = 0;
			FlxG.camera.follow(player, TOPDOWN, 1);
		}
		if (player.touching != FlxObject.FLOOR && player.touching != ExtendedCollision.EXTFLOOR)
		{
			Player.justunsticked = true;
			if (FlxG.save.data.rotcam)
				FlxG.camera.angle = 0;
			FlxG.camera.follow(player, TOPDOWN, 1);
		}
	}
	function placeEntities(entity:EntityData)
	{
		switch(entity.name)
		{
			case "player":
			{
				trace("shit");
				if (!isrespawn)
				{
					player.setPosition(entity.x, entity.y);
					FlxG.save.data.lasty = entity.y;
					FlxG.save.data.lastx = entity.x;
				}
				if (isrespawn)
					player.setPosition(FlxG.save.data.lastx, FlxG.save.data.lasty);
				Player.defaultspeed = 0;
				Player.shouldslip = false;
				Player.doublespeed = false;
				Player.Fallshit = 100;
				Player.saves = 0;
			}
			case "flop":
			{
				trace("shit");
				floppies.add(new FloppyDisk(entity.x, entity.y));
			}
		}
	}
	function playerTouchFloppy(player:Player, thing:FloppyDisk)
	{
		if (player.alive && player.exists && thing.alive && thing.exists && !FloppyDisk.alreadygrabbed)
		{
			FloppyDisk.alreadygrabbed = true;
			if (Player.saves == 0 && !FlxG.save.data.savetext)
			{
				saveicon = new FlxSprite(0, 0).loadGraphic('assets/images/ui/floppy.png');
			}
			Player.saves++;

			thing.alive = false;
			thing.exists = false;
			thing.kill();
			trace("called");
			trace(FloppyDisk.alreadygrabbed);
		}
		pickupsfx = FlxG.sound.load('assets/sounds/normal/pickup.wav');
		trace(FloppyDisk.alreadygrabbed);
		trace("called");
	}
	function pushleft(Playerthing:FlxObject, Tilecollision:FlxObject):Void
	{
		var value = sys.io.File.getContent("assets/data/level" + curlevel + "/level" + curlevel + "physics.json");
		var json = haxe.Json.parse(value);
		if (player.touching == FlxObject.FLOOR || player.touching == ExtendedCollision.WALL2 || player.touching == ExtendedCollision.WALL4)
		{
			if (Player.jumps > 0)
			{
				Player.jumps = 0;
			}
			trace("left");
			Player.shouldslip = false;
			Player.defaultspeed = -100 * json.conveyorvelocity;
		}
		if (player.touching == FlxObject.CEILING)
		{
			Player.currentangle = 0;
			Player.Fallshit = 100;
		}
	}
	function pushright(Playerthing:FlxObject, Tilecollision:FlxObject):Void
	{
		var value = sys.io.File.getContent("assets/data/level" + curlevel + "/level" + curlevel + "physics.json");
		var json = haxe.Json.parse(value);
		if (player.touching == FlxObject.FLOOR || player.touching == ExtendedCollision.WALL2 || player.touching == ExtendedCollision.WALL4)
		{
			if (Player.jumps > 0)
			{
				Player.jumps = 0;
			}
			trace("right");
			Player.shouldslip = false;
			Player.defaultspeed = 100 * json.conveyorvelocity;
		}
		if (player.touching == FlxObject.CEILING)
		{
			Player.currentangle = 0;
			Player.Fallshit = 100;
		}
	}
	function removesaved(_)
	{
		saved.kill();
	}
	function resetjumps(Playerthing:FlxObject, Tilecollision:FlxObject):Void
	{
		if (Player.currentangle == 0)
		{
			if (player.touching == FlxObject.FLOOR || player.touching == ExtendedCollision.WALL2 || player.touching == ExtendedCollision.WALL4)
			{
				if (player.velocity.x == 0)
					Player.doublespeed = false;
				Player.jumps = 0;
			}
		}
		if (player.touching == FlxObject.CEILING)
		{
			Player.currentangle = 0;
			Player.Fallshit = 100;
		}
		Player.currentangle = 0;
		Player.defaultspeed = 0;
	}
	override public function update(elapsed:Float)
	{
		var value = sys.io.File.getContent("assets/data/level" + curlevel + "/level" + curlevel + "physics.json");
		var json = haxe.Json.parse(value);
		exitconfirm();
		if (!Player.ispaused)
		{
			reset = FlxG.keys.anyPressed([R]);
			if (player.inWorldBounds() == false || reset)
				openSubState(new DeathSubState(json.deathlevel));
		}
		saveicon.y = player.y - player.height - 2;
		if (FlxG.save.data.savetext)
		{
			saveicon.x = player.x;
			saves.text = "" + Player.saves;
			saves.x = player.x + player.width/1.3;
			saves.y = player.y - player.height + 2;
		}
		if (!FlxG.save.data.savetext)
			saveicon.x = player.x + player.width - 3;
		if (Player.saves <= 0 && !FlxG.save.data.savetext)
			saveicon.kill();
		if (Player.saves < 0)
			Player.saves = 0;
		save = FlxG.keys.anyJustPressed([X]);
		if (save)
		{
			savesfx = FlxG.sound.load('assets/sounds/normal/savecomplete.wav');
			savefailsfx = FlxG.sound.load('assets/sounds/normal/savefail.wav');
			if (Player.saves == 1 && !FlxG.save.data.savetext)
			{
				saveicon.kill();
			}
			if (Player.saves >= 1)
			{
				trace("ok");
				saved = new FlxSprite(0, 0).loadGraphic('assets/images/ui/checkmark.png');
				saved.x = player.x;
				saved.y = player.y;
				FlxTween.tween(saved, {alpha: 0, y: saved.y - 16}, 0.33, {ease: FlxEase.circOut, onComplete: removesaved});
				Player.saves -= 1;
				FlxG.save.data.lastx = player.x;
				FlxG.save.data.lasty = player.y;
				return;
			}
			if (Player.saves == 0)
			{
				trace("fuck");
				saved = new FlxSprite(0, 0).loadGraphic('assets/images/ui/x.png');
				saved.x = player.x;
				saved.y = player.y;
				FlxTween.tween(saved, {alpha: 0, y: saved.y - 16}, 0.33, {ease: FlxEase.circOut, onComplete: removesaved});
				return;
			}
		}
		super.update(elapsed);
		FlxG.collide(player, floor);
		FlxG.collide(player, special);
		FlxG.overlap(player, floppies, playerTouchFloppy);
	}
	function updatedrag(Playerthing:FlxObject, Tilecollision:FlxObject):Void
	{
		var value = sys.io.File.getContent("assets/data/level" + curlevel + "/level" + curlevel + "physics.json");
		var json = haxe.Json.parse(value);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);
		Player.doublespeed = false;
		Player.shouldslip = true;
		if (player.touching == FlxObject.FLOOR)
		{
			if (left)
				Player.defaultspeed = -100 * json.icevelocity;
			if (right)
				Player.defaultspeed = 100 * json.icevelocity;
			Player.jumps = 0;
		}
	}
	function winmenu(Playerthing:FlxObject, Tilecollision:FlxObject):Void
	{
		var value = sys.io.File.getContent("assets/data/level" + curlevel + "/level" + curlevel + "physics.json");
		var json = haxe.Json.parse(value);
		if (player.touching == FlxObject.FLOOR || player.touching == ExtendedCollision.EXTFLOOR)
		{
			player.kill();
			openSubState(new NextLevelSubState(json.winlevel));
		}
	}
}
package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import haxe.Json;

class Player extends FlxSprite
{
	var up:Bool = false;
	var right:Bool = false;
	var left:Bool = false;
	var down:Bool = false;
	var save:Bool = false;
	public static var jumps:Int = 0;
	public static var SPEED:Float = 100;
	public static var Fallshit:Float = 100;
	public static var dragshit:Float = 1600;
	public static var defaultspeed:Float = 0;
	public static var justunsticked:Bool = false;
	public static var playingchar:String = "11";
	public static var ispaused:Bool = false;
	public static var shouldslip:Bool = false;
	public static var doublespeed:Bool = false;
	var randshit:Int = 1;
	var playingalready:Bool = false;
	var tex:FlxAtlasFrames;
	var jumpsound:FlxSound;
	var walksound:FlxSound;
	var saved:FlxSprite;
	public static var currentangle:Float;

	public static var escape:Bool = false;
	var frameswalk:Int = 8;
	var framesidle:Int = 4;
	var framesjump:Int = 4;
	var framesclimb:Int = 2;
	var frameshang:Int = 4;
	public static var saves:Int = 0;
	public function new(x:Float = 0, y:Float = 0)
	{
		doublespeed = false;
		var value = sys.io.File.getContent("assets/images/characters/char" + playingchar + "framerate.json");
		var json = haxe.Json.parse(value);
		trace(json);
		frameswalk = json.walk;
		framesidle = json.idle;
		framesjump = json.jump;
		framesclimb = json.climb;
		frameshang = json.hang;
		super(x, y);
		//var tex:FlxAtlasFrames;
		tex = tex = FlxAtlasFrames.fromSparrow('assets/images/characters/char' + playingchar + '.png', 'assets/images/characters/char' + playingchar + '.xml');
		frames = tex;
		animation.addByPrefix('walk', 'Walk Anim', frameswalk, false);
		animation.addByPrefix('idle', 'Idle Anim', framesidle, false);
		animation.addByPrefix('jump', 'Jump Anim', framesjump, false);
		animation.addByPrefix('climb', 'Climb Anim', framesclimb, false);
		animation.addByPrefix('hang', 'Hang Anim', frameshang, false);
		drag.x = dragshit;
	}
	function settofalse()
	{
		playingalready = false;
	}
	function updateMovement()
	{
		if (!ispaused)
		{
			//MESSY AS SHIT I KNOW IM SORRY FORGIVE ME
			jumpsound = FlxG.sound.load('assets/sounds/normal/jump.wav');
			walksound = FlxG.sound.load('assets/sounds/normal/walk.wav');

			switch currentangle
			{
				case 0:
				{
					velocity.set(defaultspeed, Fallshit);
					switch FlxG.save.data.rotkeys
					{
						case false:
						{
							up = FlxG.keys.anyPressed([UP, W, SPACE]);
							left = FlxG.keys.anyPressed([LEFT, A]);
							right = FlxG.keys.anyPressed([RIGHT, D]);
							down = FlxG.keys.anyPressed([DOWN, S]);
						}
						case true:
						{
							switch FlxG.camera.angle
							{
								case 0:
								{
									up = FlxG.keys.anyPressed([UP, W, SPACE]);
									left = FlxG.keys.anyPressed([LEFT, A]);
									right = FlxG.keys.anyPressed([RIGHT, D]);
									down = FlxG.keys.anyPressed([DOWN, S]);
								}
								case -180:
								{
									up = FlxG.keys.anyPressed([DOWN, S, SPACE]);
									left = FlxG.keys.anyPressed([RIGHT, D]);
									right = FlxG.keys.anyPressed([LEFT, A]);
									down = FlxG.keys.anyPressed([UP, W]);
								}
							}
						}
					}
					if (left && right)
				 		left = right = false;
				 	if (down && up)
				 		down = up = false;
				 	if (right || left || up || down)
					{
						if (down)
							Fallshit = 200;
						if (left)
							SPEED = -100 * (doublespeed ? 2 : 1);
							facing = FlxObject.LEFT;
						if (right)
							SPEED = 100 * (doublespeed ? 2 : 1);
							facing = FlxObject.RIGHT;
						if (up && jumps == 0)
						{
							jumpsound.play();
							trace(jumps);
							trace(Fallshit);
							Fallshit = -105;
							jumps++;
							SPEED = 0;
							if (left)
								SPEED = -100 * (doublespeed ? 2 : 1);
							if (right)
								SPEED = 100 * (doublespeed ? 2 : 1);
							new FlxTimer().start(0.1, function(tmr:FlxTimer)
							{
								if (ispaused)
								{
									tmr.active = false;
								}
								if (!ispaused)
								{
									tmr.active = true;
								}
								if (currentangle != 0)
									tmr.destroy();
								if (Fallshit != 100)
								{
									tmr.reset();
									if (Fallshit < 0)
										Fallshit += 10;
									if (Fallshit > 0)
										Fallshit += 100;
									if (Fallshit > 100)
										Fallshit = 100;
									trace(Fallshit);
								}
								else
								{
									tmr.destroy();
								}
							});
						}
						if (ispaused)
						{
							velocity.set(0, 0);
						}
						if (!ispaused)
							velocity.set(SPEED, Fallshit);
						if (velocity.x != 0) 
						{
							if (touching == FlxObject.FLOOR /*|| touching == ExtendedCollision.WALL1  || touching == ExtendedCollision.WALL2 || touching == ExtendedCollision.WALL3 || touching == ExtendedCollision.WALL4*/)
							{
								
								animation.play("walk");
								if (left)
									flipX = true;
								if (right)
									flipX = false;
							}
							if (touching != FlxObject.FLOOR /*|| touching != ExtendedCollision.WALL1  || touching != ExtendedCollision.WALL2 || touching != ExtendedCollision.WALL3 || touching != ExtendedCollision.WALL4*/)
							{
								animation.play("jump");
								if (left)
									flipX = true;
								if (right)
									flipX = false;
							}
						}
						else
						{
							animation.play("idle");
						}
					}
					
				}
				case -90:
				{
					velocity.set(Fallshit, defaultspeed);
					switch FlxG.save.data.rotkeys
					{
						case false:
						{
							up = FlxG.keys.anyPressed([UP, W, SPACE]);
							left = FlxG.keys.anyPressed([LEFT, A]);
							right = FlxG.keys.anyPressed([RIGHT, D]);
							down = FlxG.keys.anyPressed([DOWN, S]);
						}
						case true:
						{
							switch FlxG.camera.angle
							{
								case 0:
								{
									up = FlxG.keys.anyPressed([RIGHT, D, SPACE]);
									right = FlxG.keys.anyPressed([DOWN, S]);
									left = FlxG.keys.anyPressed([UP, W]);
									down = FlxG.keys.anyPressed([LEFT, A]);
								}
								case -180:
								{
									up = FlxG.keys.anyPressed([LEFT, A, SPACE]);
									right = FlxG.keys.anyPressed([UP, W]);
									left = FlxG.keys.anyPressed([DOWN, S]);
									down = FlxG.keys.anyPressed([RIGHT, D]);
								}
							}
						}
					}
					if (left && right)
				 		left = right = false;
				 	if (down && up)
				 		down = up = false;
				 	if (right || left || up || down)
					{
						if (down)
							Fallshit = 200;
						if (left)
							SPEED = -100 * (doublespeed ? 2 : 1);
							facing = FlxObject.LEFT;
						if (right)
							SPEED = 100 * (doublespeed ? 2 : 1);
							facing = FlxObject.RIGHT;
						if (up)
						{
							justunsticked = true;
						}
						if (up && jumps == 0)
						{
							jumpsound.play();
							trace(jumps);
							trace(Fallshit);
							Fallshit = -105;
							jumps++;
							SPEED = 0;
							if (left)
								SPEED = -100 * (doublespeed ? 2 : 1);
							if (right)
								SPEED = 100 * (doublespeed ? 2 : 1);
							new FlxTimer().start(0.1, function(tmr:FlxTimer)
							{
								if (ispaused)
								{
									tmr.active = false;
								}
								if (!ispaused)
								{
									tmr.active = true;
								}
								if (currentangle != -90)
									tmr.destroy();
								if (Fallshit != 100)
								{
									tmr.reset();
									if (Fallshit < 0)
										Fallshit += 10;
									if (Fallshit > 0)
										Fallshit += 100;
									if (Fallshit > 100)
										Fallshit = 100;
									trace(Fallshit);
								}
								else
								{
									tmr.destroy();
								}
							});
						}
						if (ispaused)
						{
							velocity.set(0, 0);
						}
						if (!ispaused)
							velocity.set(Fallshit, SPEED);
						if (velocity.y != 0) 
						{
							if (touching == FlxObject.RIGHT)
							{
								
								animation.play("climb");
							}
							else
							{
								animation.play("jump");
								if (left)
									flipX = false;
								if (right)
									flipX = true;
							}
						}
						else
						{
							animation.play("idle");
						}
					}
					
				}
				case 90:
				{
					velocity.set(Fallshit, defaultspeed);
					switch FlxG.save.data.rotkeys
					{
						case false:
						{
							up = FlxG.keys.anyPressed([UP, W, SPACE]);
							left = FlxG.keys.anyPressed([LEFT, A]);
							right = FlxG.keys.anyPressed([RIGHT, D]);
							down = FlxG.keys.anyPressed([DOWN, S]);
						}
						case true:
						{
							switch FlxG.camera.angle
							{
								case 0:
								{
									up = FlxG.keys.anyPressed([LEFT, A, SPACE]);
									right = FlxG.keys.anyPressed([DOWN, S]);
									left = FlxG.keys.anyPressed([UP, W]);
									down = FlxG.keys.anyPressed([RIGHT, D]);
								}
								case -180:
								{
									up = FlxG.keys.anyPressed([RIGHT, D, SPACE]);
									right = FlxG.keys.anyPressed([UP, W]);
									left = FlxG.keys.anyPressed([DOWN, S]);
									down = FlxG.keys.anyPressed([LEFT, A]);
								}
							}
						}
					}
					if (left && right)
				 		left = right = false;
				 	if (down && up)
				 		down = up = false;
				 	if (right || left || up || down)
					{
						if (down)
							Fallshit = -200;
						if (left)
							SPEED = -100 * (doublespeed ? 2 : 1);
							facing = FlxObject.LEFT;
						if (right)
							SPEED = 100 * (doublespeed ? 2 : 1);
							facing = FlxObject.RIGHT;
						if (up)
						{
							justunsticked = true;
						}
						if (up && jumps == 0)
						{
							jumpsound.play();
							trace(jumps);
							trace(Fallshit);
							Fallshit = 105;
							jumps++;
							SPEED = 0;
							if (left)
								SPEED = -100 * (doublespeed ? 2 : 1);
							if (right)
								SPEED = 100 * (doublespeed ? 2 : 1);
							new FlxTimer().start(0.1, function(tmr:FlxTimer)
							{
								if (ispaused)
								{
									tmr.active = false;
								}
								if (!ispaused)
								{
									tmr.active = true;
								}
								if (currentangle != 90)
									tmr.destroy();
								if (Fallshit != -100)
								{
									tmr.reset();
									if (Fallshit > 0)
										Fallshit -= 10;
									if (Fallshit < 0)
										Fallshit -= 100;
									if (Fallshit < -100)
										Fallshit = -100;
									trace(Fallshit);
								}
								else
								{
									tmr.destroy();
								}
							});
						}
						if (ispaused)
						{
							velocity.set(0, 0);
						}
						if (!ispaused)
							velocity.set(Fallshit, SPEED);
						if (velocity.y != 0) 
						{
							if (touching == FlxObject.LEFT)
							{
								animation.play("climb");
								flipX = true;
							}
							else
							{
								animation.play("jump");
								if (left)
									flipX = true;
								if (right)
									flipX = false;
							}
						}
						else
						{
							animation.play("idle");
						}
					}
					
				}
				case -180:
				{
					velocity.set(defaultspeed, Fallshit);
					switch FlxG.save.data.rotkeys
					{
						case false:
						{
							up = FlxG.keys.anyPressed([UP, W, SPACE]);
							left = FlxG.keys.anyPressed([LEFT, A]);
							right = FlxG.keys.anyPressed([RIGHT, D]);
							down = FlxG.keys.anyPressed([DOWN, S]);
						}
						case true:
						{
							switch FlxG.camera.angle
							{
								case 0:
								{
									up = FlxG.keys.anyPressed([DOWN, S, SPACE]);
									left = FlxG.keys.anyPressed([LEFT, A]);
									right = FlxG.keys.anyPressed([RIGHT, D]);
									down = FlxG.keys.anyPressed([UP, W]);
								}
								case -180:
								{
									up = FlxG.keys.anyPressed([UP, W, SPACE]);
									left = FlxG.keys.anyPressed([RIGHT, D]);
									right = FlxG.keys.anyPressed([LEFT, A]);
									down = FlxG.keys.anyPressed([DOWN, S]);
								}
							}
						}
					}
					if (left && right)
				 		left = right = false;
				 	if (down && up)
				 		down = up = false;
				 	if (right || left || up || down)
					{
						if (down)
							Fallshit = -200;
						if (left)
							SPEED = -100 * (doublespeed ? 2 : 1);
							facing = FlxObject.LEFT;
						if (right)
							SPEED = 100 * (doublespeed ? 2 : 1);
							facing = FlxObject.RIGHT;
						if (up && jumps == 0)
						{
							jumpsound.play();
							trace(jumps);
							trace(Fallshit);
							Fallshit = 105;
							jumps++;
							SPEED = 0;
							if (left)
								SPEED = -100 * (doublespeed ? 2 : 1);
							if (right)
								SPEED = 100 * (doublespeed ? 2 : 1);
							new FlxTimer().start(0.1, function(tmr:FlxTimer)
							{
								if (ispaused)
								{
									tmr.active = false;
								}
								if (!ispaused)
								{
									tmr.active = true;
								}
								if (currentangle != -180)
									tmr.destroy();
								if (Fallshit != -100)
								{
									tmr.reset();
									if (Fallshit > 0)
										Fallshit -= 10;
									if (Fallshit < 0)
										Fallshit -= 100;
									if (Fallshit < -100)
										Fallshit = -100;
									trace(Fallshit);
								}
								else
								{
									tmr.destroy();
								}
							});
						}
						if (ispaused)
						{
							velocity.set(0, 0);
						}
						if (!ispaused)
							velocity.set(SPEED, Fallshit);
						if (velocity.x != 0) 
						{
							if (touching == FlxObject.CEILING)
							{
								
								animation.play("hang");
								if (left)
									flipX = true;
								if (right)
									flipX = false;
							}
						}
						else
						{
							animation.play("jump");
						}
					}
					if (velocity.x != 0 && !playingalready) 
					{
						playingalready = true;
						new FlxTimer().start(0.35, function(tmr:FlxTimer)
						{
							if (ispaused)
							{
								tmr.active = false;
							}
							if (!ispaused)
							{
								tmr.active = true;
							}
							playingalready = false;
							tmr.destroy();
						}); 
					}
				}
			}
		}
	}
	function removesaved(_)
	{
		saved.kill();
	}
	override function update(elapsed:Float)
 	{
 		escape = FlxG.keys.anyJustPressed([ESCAPE, DELETE]);
		if (escape)
		{
			ispaused = !ispaused;
		}
 		if (!ispaused)
 		{
	 		//velocity.rotate(FlxPoint.weak(0, 0), 0);
			//angle = 0;
			if (currentangle == 0 && touching == FlxObject.FLOOR && velocity.x == 0)
			{
				animation.play("idle");
			}
			if (currentangle == -180 && touching == FlxObject.CEILING && velocity.x == 0)
			{
				animation.play("jump");
			}
			if (currentangle == -180 && touching == FlxObject.NONE)
			{
				Fallshit = -105;
			}
			if (touching == FlxObject.NONE)
			{
				shouldslip = false;
				animation.play("jump");
				currentangle = 0;
			}
		 	updateMovement();
		 	up = FlxG.keys.anyPressed([UP, W, SPACE]);
			left = FlxG.keys.anyPressed([LEFT, A]);
			right = FlxG.keys.anyPressed([RIGHT, D]);
			down = FlxG.keys.anyPressed([DOWN, S]);
			if (touching == FlxObject.NONE)
			{
				defaultspeed = 0;
				if (justunsticked == true)
				{
					justunsticked = false;
					currentangle = 0;
					Fallshit = -105;
					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
					if (ispaused)
						{
							tmr.active = false;
						}
						if (!ispaused)
						{
							tmr.active = true;
						}
						if (currentangle != 0)
								tmr.destroy();
						if (Fallshit != 100)
						{
							tmr.reset();
							if (Fallshit < 0)
								Fallshit += 10;
							if (Fallshit > 0)
								Fallshit += 100;
							if (Fallshit > 100)
								Fallshit = 100;
							trace(Fallshit);
						}
						else
						{
							tmr.destroy();
						}
					});
				}
			}
	 		if (up || down && !left && !right && SPEED != 0)
	 			SPEED = 0;
	 		if (currentangle == 0 || currentangle == -90)
	 		{
				if (Fallshit > 100)
				{
					Fallshit = 100;
				}
	 		}
	 		if (currentangle == 90 || currentangle == -180)
	 		{
				if (Fallshit < -100)
				{
					Fallshit = -100;
				}
	 		}
	 		if (shouldslip)
	 		{
				if (defaultspeed < 3)
				{
					defaultspeed += 0.5;
					if (defaultspeed > 2.9)
					{
						defaultspeed = 0;
					}
				}
				if (defaultspeed > 3)
				{
					defaultspeed -= 0.5;
					if (defaultspeed < 2.9)
					{
						defaultspeed = 0;
					}
				}
				if (defaultspeed < 1.1 && defaultspeed > -1.1)
					defaultspeed = 0;
				if (defaultspeed == 3)
					defaultspeed = 0;
			}
			if (Fallshit == 0)
			{
				if (currentangle == -90 || currentangle == 0)
					Fallshit = 100;
				if (currentangle == -180 || currentangle == 90)
					Fallshit = -100;
			}
			//trace(justunsticked);
		 	super.update(elapsed);
		}
		if (ispaused)
		{
		}
	}
}
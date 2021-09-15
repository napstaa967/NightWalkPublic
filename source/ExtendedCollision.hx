package;

import flixel.FlxObject;

class ExtendedCollision extends FlxObject
{
	public static inline var WALL1:Int = FlxObject.LEFT + FlxObject.UP;
	public static inline var WALL2:Int = FlxObject.LEFT + FlxObject.DOWN;
	public static inline var WALL3:Int = FlxObject.RIGHT + FlxObject.UP;
	public static inline var WALL4:Int = FlxObject.RIGHT + FlxObject.DOWN;
	public static inline var EXTWALLS:Int = WALL1 | WALL2 | WALL3 | WALL4;
	public static inline var EXTCEILING:Int = WALL1 | WALL3;
	public static inline var EXTFLOOR:Int = WALL2 | WALL4;
}

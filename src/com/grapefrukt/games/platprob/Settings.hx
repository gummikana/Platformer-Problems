package com.grapefrukt.games.platprob;
import box2D.common.math.B2Vec2;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Settings{

	static public inline var STAGE_W			:Int = 800;
	static public inline var STAGE_H			:Int = 480;
	static public inline var PHYSICS_SCALE		:Float = 1 / 30;
	static public inline var PHYSICS_STEP_DURATION	:Float = 1 / 60;
	
	public static function psb2(x:Float, y:Float):B2Vec2 {
		return new B2Vec2(x * PHYSICS_SCALE, y * PHYSICS_SCALE);
	}
	
}
package com.grapefrukt.games.platprob;
import box2D.common.math.B2Vec2;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Settings{

	static public inline var STAGE_W					:Int = 800;
	static public inline var STAGE_H					:Int = 480;
	
	static public inline var PHYSICS_SCALE				:Float = 1 / 30;
	static public inline var PHYSICS_STEP_DURATION		:Float = 1 / 60;
	static public inline var PHYSICS_GRAVITY			:Float = 10 * 9.8;	// 10 * 9.8
	
	static public inline var PLATFORMING_JUMP_VELOCITY			:Float = -4375 * 1.5;	// for 10x gravity -10000, -2000 for normal gravity
	static public inline var PLATFORMING_CLAMP_JUMP				:Bool = false;
	static public inline var PLATFORMING_USE_IN_AIR_COUNTER		:Bool = true;
	static public inline var PLATFORMING_AIR_COUNTER_MAX		:Int = 10;

	static public inline var PLATFORMING_HORIZONTAL_VELOCITY_ON_GROUND:Float = 250;
	static public inline var PLATFORMING_HORIZONTAL_VELOCITY_IN_AIR:Float = 0.75 * 250;

	static public inline var PLAYER_WHEEL_STOP			:Bool = true;
	static public inline var PLAYER_GROUND_SLOWDOWN		:Bool = true;
	static public inline var PLAYER_GROUND_SLOWDOWN_LENGTH:Int = 5;

	static public inline var PLAYER_WIDTH				:Float = 1.0;	// in meters
	static public inline var PLAYER_HEIGHT				:Float = 1.8;	// in meters

	static public inline var PLAYER_FIXED_ROTATION		:Bool = true;
	static public inline var PLAYER_BALANCE_ROTATION	:Bool = false;
	static public inline var PLAYER_BALANCE_STRENGTH	:Float = 25.0;
	static public inline var PLAYER_EXTRA_DRUNK			:Bool = false;
	
	
	static public inline var PLAYER_FRICTION			:Float = 10;
	static public inline var PLAYER_RESTITUTION			:Float = .1;
	static public inline var PLAYER_DENSITY				:Float = 1;
	
	static public inline var BOUNDS_FRICTION			:Float = 1;
	static public inline var BOUNDS_RESTITUTION			:Float = .1;

	static public inline var COLOR_PLAYER_BODY			:Int = 0x00c653;
	static public inline var COLOR_PLAYER_BODY_PILLS	:Int = 0x00AF49;
	static public inline var COLOR_PLAYER_WHEEL			:Int = 0x6F3AAF;
	static public inline var COLOR_TERRAIN				:Int = 0x4587B6;
	
	static public inline var CAMERA_SMOOTHING			:Float = 0.05;
	static public inline var CAMERA_VELOCITY_LEAD_X		:Float = 15;
	static public inline var CAMERA_VELOCITY_LEAD_Y		:Float = 5;
	
	public static function psb2(x:Float, y:Float):B2Vec2 {
		return new B2Vec2(x * PHYSICS_SCALE, y * PHYSICS_SCALE);
	}
	
}
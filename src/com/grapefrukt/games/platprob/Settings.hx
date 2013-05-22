package com.grapefrukt.games.platprob;
import box2D.common.math.B2Vec2;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Settings{

	static public inline var STAGE_W					:Int = 1280;
	static public inline var STAGE_H					:Int = 720;
	
	static public inline var PHYSICS_SCALE				:Float = 1 / 30;
	@range(0.0083333333,0.0333333333) static public var PHYSICS_STEP_DURATION				:Float = 1 / 60;
	@range(1,200) static public var PHYSICS_GRAVITY										:Float = 9.8;	// 10 * 9.8
	
	static public var USE_VPLAYER							:Bool = false;
	
	
	@range(-10000.0, -100.0) static public var PLATFORMING_JUMP_VELOCITY				:Float = -4375; // -400 for 1.8 h, -4375 * 1.5;	// for 10x gravity -10000, -2000 for normal gravity
	static public var PLATFORMING_CLAMP_JUMP				:Bool = false;
	static public var PLATFORMING_USE_IN_AIR_COUNTER		:Bool = true;
	static public var PLATFORMING_AIR_COUNTER_MAX			:Int = 10;

	@range(100, 1000.0) static public var PLATFORMING_HORIZONTAL_VELOCITY_ON_GROUND:Float = 250;
	static public var PLATFORMING_HORIZONTAL_VELOCITY_IN_AIR:Float = 0.75 * 250;

	static public var PLATFORMING_TOUCH_GROUND_IN_USE	:Bool = true;
	
	static public var PLAYER_IS_A_BOX					:Bool = true;
	static public var PLAYER_PILL_BOX_SIZE_LESS			:Float = 0.3;
	
	@reset(true) static public var PLAYER_START_POSITION_X			:Float = 10.4;
	@reset(true) static public var PLAYER_START_POSITION_Y			:Float = 10.0;
	
	
	static public var PLAYER_WHEEL_STOP					:Bool = true;
	static public var PLAYER_GROUND_SLOWDOWN			:Bool = true;
	static public var PLAYER_GROUND_SLOWDOWN_LENGTH		:Int = 5;
	static public var PLAYER_CLAMP_VELOCITY				:Bool = true;
	static public var PLAYER_MAX_HORIZONTAL_VELOCITY	:Float = 25.0;

	static public var TILE_SIZE							:Float = 1.0;	// in meters
	static public var PLAYER_WIDTH						:Float = 1.0;	// in meters
	@range(1.0,4.0) static public var PLAYER_HEIGHT		:Float = 1.8;	// in meters

	static public var PLAYER_FIXED_ROTATION			:Bool = false;
	static public var PLAYER_BALANCE_ROTATION		:Bool = false;
	static public var PLAYER_BALANCE_STRENGTH		:Float = 25.0;
	static public var PLAYER_EXTRA_DRUNK			:Bool = false;
	
	
	@range(0, 10)static public var PLAYER_FRICTION				:Float = 10;
	static public var PLAYER_RESTITUTION			:Float = .1;
	static public var PLAYER_DENSITY				:Float = 1;
	
	static public var VPLAYER_FRICTION				:Float = 0;
	static public var VPLAYER_RESTITUTION			:Float = 0;
	static public var VPLAYER_DENSITY				:Float = 1;
	@range(0.001, 1) static public var VPLAYER_DELTA					:Float = 1.0;
	static public var VPLAYER_JUMP_VELOCITY			:Float = -39;
	static public var VPLAYER_HORIZONTAL_VELOCITY	:Float = 1.5;
	static public var VPLAYER_GRAVITY				:Float = 98;
	static public var VPLAYER_TERMINAL_VELOCITY		:Float = 50;
	static public var VPLAYER_MAX_HORIZONTAL_SPEED	:Float = 25;
	static public var VPLAYER_SLOWDOWN_MULTIPLIER	:Float = 0.75;
	
	static public var VPLAYER_RAYCAST 				:Bool = true;
	static public var VPLAYER_RESPOND_TO_CONTACTS	:Bool = true;
	
	static public var BOUNDS_FRICTION				:Float = 0.8;
	static public var BOUNDS_RESTITUTION			:Float = .1;

	static public inline var COLOR_PLAYER_BODY			:Int = 0x00c653;
	static public inline var COLOR_PLAYER_BODY_PILLS	:Int = 0x00AF49;
	static public inline var COLOR_PLAYER_WHEEL			:Int = 0x6F3AAF;
	static public inline var COLOR_TERRAIN				:Int = 0x4587B6;
	
	@range(0.05, 1) static public var CAMERA_SMOOTHING						:Float = 0.05;
	@range(0, 30) static public var CAMERA_VELOCITY_LEAD_X		:Float = 15;
	@range(0, 30) static public var CAMERA_VELOCITY_LEAD_Y		:Float = 5;
	
}
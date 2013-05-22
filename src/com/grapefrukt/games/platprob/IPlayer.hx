package com.grapefrukt.games.platprob;
import box2D.dynamics.B2Body;

/**
 * ...
 * @author ...
 */
class IPlayer{

	public var body(default, null):B2Body;
	public var isOnGround(default, null):Bool;
	
	// stats
	public var jumpTime:Int;
	public var jumpTimeStart:Int;
	public var jumpHeight:Float;
	public var jumpHighest:Float;
	public var jumpHeightStart:Float;

	public function jump() : Void { }
	public function stopJump() : Void { }
	
	public function applyHorizontalMove( direction:Float ):Void  { }
	
	public function update(timeDelta:Float) :Void { }

		
	public function new() {
		
	}
	
}
package com.grapefrukt.utils;
import flash.geom.Point;
/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Shaker {
	
	private static var _velocity	:Point;
	private static var _position	:Point;
	private static var _target		:Dynamic;
	private static var _drag		:Float;
	private static var _elasticity	:Float;
	
	private static var _shakeDuration:Float;
	
	public static function init(target:Dynamic) {
		_target = target;
		_velocity = new Point();
		_position = new Point();
		_drag = .2;
		_elasticity = .2;
	}
	
	public static function shake(powerX:Float, powerY:Float):Void {
		_velocity.x += powerX;
		_velocity.y += powerY;
	}
	
	public static function shakeRandom(power:Float):Void {
		_velocity = Point.polar(power, Math.random() * Math.PI * 2);
	}
	
	public static function shakeDuration(time:Float):Void {
		_shakeDuration = time;
	}
	
	public static function update(delta:Float):Void {
		if (_shakeDuration > 0) {
			shakeRandom(3);
			_shakeDuration -= delta;
		}
		
		delta = 1;
		
		_velocity.x -= _velocity.x * _drag * delta;
		_velocity.y -= _velocity.y * _drag * delta;
		
		_velocity.x -= (_position.x) * _elasticity * delta;
		_velocity.y -= (_position.y) * _elasticity * delta;
		
		_position.x += (_velocity.x) * delta;
		_position.y += (_velocity.y) * delta;
		
		_target.x = Std.int(_position.x);
		_target.y = Std.int(_position.y);
	}
	
}

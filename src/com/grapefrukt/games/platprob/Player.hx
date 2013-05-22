package com.grapefrukt.games.platprob;
import box2D.common.math.B2Math;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2World;
import box2D.dynamics.contacts.B2Contact;
import com.grapefrukt.games.platprob.physics.PhysUtils;
import nme.Lib;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Player extends IPlayer {
	
	public var wheel(default, null):B2Body;
	public var inAirCounter:Int;
	public var keyPressed:Int;
	public var contacts:Array< B2Contact >;
	
	// stats
	public var jumpTime:Int;
	public var jumpTimeStart:Int;
	public var jumpHeight:Float;
	public var jumpHighest:Float;
	public var jumpHeightStart:Float;

	
	public function new(world:B2World) {
		super();
		contacts = [];
		
		for ( i in 0...10 ) {
			var box = PhysUtils.createBoxInMeters(world, 10 + i * 1.5, 30, 1.0, 1.0, true, 0.5, .5, Settings.PLAYER_DENSITY);
		}
		
		if ( Settings.PLAYER_IS_A_BOX ) 
		{
			body = PhysUtils.createBoxInMeters(world, Settings.PLAYER_START_POSITION_X, Settings.PLAYER_START_POSITION_Y, Settings.PLAYER_WIDTH, Settings.PLAYER_HEIGHT, true, Settings.PLAYER_FRICTION, Settings.PLAYER_RESTITUTION, Settings.PLAYER_DENSITY, Settings.COLOR_PLAYER_BODY);
			body.setFixedRotation( Settings.PLAYER_FIXED_ROTATION );
			
			// wheel = body;
			body.setUserData( this );
		}
		else
		{
			// body = PhysUtils.createBoxInMeters(world, 10, 10, Settings.PLAYER_WIDTH, Settings.PLAYER_HEIGHT, true, Settings.PLAYER_FRICTION, Settings.PLAYER_RESTITUTION, Settings.PLAYER_DENSITY);
			// var body_t = PhysUtils.createBoxInMeters(world, 8.5, 10, Settings.PLAYER_WIDTH, Settings.PLAYER_HEIGHT , true );
			var body_parts = PhysUtils.createPlayerInMeters(world, 10, 10, Settings.PLAYER_WIDTH, Settings.PLAYER_HEIGHT, true, Settings.PLAYER_FRICTION, Settings.PLAYER_RESTITUTION, Settings.PLAYER_DENSITY);
			
			body = body_parts[ 0 ];
			body.setFixedRotation( Settings.PLAYER_FIXED_ROTATION );
			// body.setUserData(this);
			
			wheel = body_parts[ 1 ];
			wheel.setUserData( this );
		}
		isOnGround = false;
		inAirCounter = 0;
		jumpTimeStart = 0;
		jumpHeightStart = 0;
		keyPressed = 0;
	}
	
	override public function update(timeDelta:Float) :Void {
		// isOnGround = false;
		
		for ( i in 0...contacts.length ) {
			onContact( contacts[ i ] );			
		}
		
		
		if ( Settings.PLATFORMING_USE_IN_AIR_COUNTER == false ) {
			isOnGround = false;
		} else {
			inAirCounter++;
			if ( inAirCounter >= Settings.PLATFORMING_AIR_COUNTER_MAX ) isOnGround = false;
		}

		if ( Settings.PLATFORMING_TOUCH_GROUND_IN_USE == false ) isOnGround = true;
		
		if ( jumpHeightStart != 0 && body.getPosition().y < jumpHighest ) jumpHighest = body.getPosition().y;
		
		if ( Settings.PLAYER_BALANCE_ROTATION )
		{
			var angle:Float = body.getAngle();
			if ( angle != 0 )
			{
				var ang_vel:Float = body.getAngularVelocity();
				ang_vel += -angle * Settings.PLAYER_BALANCE_STRENGTH;
				body.setAngularVelocity( ang_vel );
			}
		}
		
		/*
		if ( keyPressed == false && Settings.PLAYER_WHEEL_STOP ) { wheel.setFixedRotation( true ); wheel.setAngularVelocity( 0 ); }

		if ( keyPressed ) keyPressed = false;
		*/
		
		keyPressed++;
		if ( Settings.PLAYER_GROUND_SLOWDOWN && wheel != null )
		{
			if ( keyPressed > 1 && keyPressed < Settings.PLAYER_GROUND_SLOWDOWN_LENGTH ) {  wheel.setAngularDamping( 0.75 + keyPressed / Settings.PLAYER_GROUND_SLOWDOWN_LENGTH ); }
			if ( keyPressed >= Settings.PLAYER_GROUND_SLOWDOWN_LENGTH ) { wheel.setFixedRotation( true ); wheel.setAngularVelocity( 0 ); }
		}
		
		if( Settings.PLAYER_CLAMP_VELOCITY ) 
		{
			var velocity = body.getLinearVelocity();
			if ( Math.abs( velocity.x ) > Settings.PLAYER_CLAMP_MAX_VELOCITY ) { velocity.x = B2Math.clamp( velocity.x, -Settings.PLAYER_CLAMP_MAX_VELOCITY, Settings.PLAYER_CLAMP_MAX_VELOCITY ); }
			body.setLinearVelocity( velocity );
		}
			
	}
	
	override public function jump():Void {
		body.applyForce( new B2Vec2( 0, Settings.PLATFORMING_JUMP_VELOCITY ), body.getWorldCenter() );
		
		// isOnGround = false;
		inAirCounter = Settings.PLATFORMING_AIR_COUNTER_MAX * 5;
		jumpTimeStart = Lib.getTimer();
		jumpHeightStart = body.getPosition().y;
		jumpHighest = jumpHeightStart;
	}
	
	override public function stopJump():Void  {
		var v = body.getLinearVelocityFromLocalPoint(body.getLocalCenter());
		if (v.y > 0) return;
		v.y = 0;
		body.setLinearVelocity(v);
	}
	
	
	
	override public function applyHorizontalMove( direction:Float ):Void  {
		if ( isOnGround ){
			body.applyForce( new B2Vec2( direction * Settings.PLATFORMING_HORIZONTAL_VELOCITY_ON_GROUND), body.getWorldCenter() );
			// trace( "On ground" );
		}
		else {
			body.applyForce( new B2Vec2( direction * Settings.PLATFORMING_HORIZONTAL_VELOCITY_IN_AIR), body.getWorldCenter() );
			// trace( "on air" );
		}
		if( wheel != null )
			wheel.setFixedRotation( false );
			
		keyPressed = 0;
	}
	
	public function touchGround() {
		// trace( "touched ground" );
		if ( isOnGround == false && jumpTimeStart != 0 ) {
			jumpTime = Lib.getTimer() - jumpTimeStart;
			jumpTimeStart = 0;
			jumpHeight = jumpHighest - jumpHeightStart;
			jumpHeightStart = 0;
			
			Lib.trace( "" );
			Lib.trace( jumpTime + "ms" );
			Lib.trace( Math.round(-jumpHeight / Settings.PLAYER_HEIGHT * 10) / 10 +"x");
		}
		isOnGround = true;
		inAirCounter = 0;
	}

	
	public function addContact( contact:B2Contact ):Void {
		contacts.push( contact );
		// onContact( contact );
	}
	
	public function endContact( contact:B2Contact ):Void {
		contacts.remove( contact );
	}
	
	
	public function onContact( contact:B2Contact):Void {
		if( contact != null && contact.isTouching() )
			touchGround();
	}
}
package com.grapefrukt.games.platprob;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2World;
import box2D.dynamics.B2Body;
import com.grapefrukt.games.platprob.physics.ContactFilter;
import com.grapefrukt.games.platprob.physics.ContactListener;
import com.grapefrukt.games.platprob.physics.PhysUtils;
import com.grapefrukt.utils.KeyInputUtil;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.ui.Keyboard;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Game extends Sprite {

	private var world:B2World;
	private var physicsDebug:Sprite;
	private var input:KeyInputUtil;
	private var player:Player;
	
	public function new() {
		super();
	}
	
	public function init() {
		
		world = new B2World(new B2Vec2(0, Settings.PHYSICS_GRAVITY ), false);
		var contacts = new ContactListener();
		world.setContactListener(contacts);
		world.setContactFilter(new ContactFilter());
		
		physicsDebug = new Sprite();
		addChild(physicsDebug);
		
		var debugDraw = new B2DebugDraw();
		debugDraw.setSprite(physicsDebug);
		debugDraw.setDrawScale(1 / Settings.PHYSICS_SCALE);
		debugDraw.setFlags(B2DebugDraw.e_shapeBit | B2DebugDraw.e_jointBit);
		debugDraw.setFillAlpha(0);
		debugDraw.setLineThickness(2);
		
		world.setDebugDraw(debugDraw);
		
		input = new KeyInputUtil(stage);
		input.map(Keyboard.LEFT, Input.LEFT);
		input.map(Keyboard.RIGHT, Input.RIGHT);
		input.map(Keyboard.Z, Input.JUMP);
		
		addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		
		reset();
	}
	
	public function reset() {
		// destroy all joints
		var joint = world.getJointList();
		while (joint != null) {
			world.destroyJoint(joint);
			joint = joint.getNext();
		}
		
		// destroy all bodies
		var body = world.getBodyList();
		while (body != null) {
			world.destroyBody(body);
			body = body.getNext();
		}
		
		// create screen bounds
		PhysUtils.createBox(world, Settings.STAGE_W / 2, Settings.STAGE_H + 50, Settings.STAGE_W, 100, false); // bottom
		PhysUtils.createBox(world, Settings.STAGE_W / 2, -50, Settings.STAGE_W, 100, false); // top
		PhysUtils.createBox(world, -50, Settings.STAGE_H / 2, 100, Settings.STAGE_H, false); // right
		PhysUtils.createBox(world, Settings.STAGE_W + 50, Settings.STAGE_H / 2, 100, Settings.STAGE_H, false); // left
		
		player = new Player(world);

		
	}
	
	public function applyJump( body:B2Body ) {
		player.body.applyForce( new B2Vec2( 0, -10000 ), new B2Vec2( 0, 0 ) );
	}
	
	public function applyHorizontalMove( body:B2Body, direction:Float )
	{
		body.applyForce( new B2Vec2( direction * Settings.PLATFORMING_HORIZONTAL_MOVE_VELOCITY), new B2Vec2() );
	}
	
	public function handleEnterFrame(e:Event) {
		world.step(Settings.PHYSICS_STEP_DURATION, 10, 10);
		world.clearForces();
		world.drawDebugData();
		
		// playerBody.applyForce( new B2Vec2( 0, -100 ), new B2Vec2() );
		if ( input.isDown(Input.JUMP, true) ) applyJump( player.body );
		if ( input.isDown(Input.LEFT, false) ) applyHorizontalMove( player.body, -1.0 );
		if ( input.isDown(Input.RIGHT, false) ) applyHorizontalMove( player.body, 1.0 );
	}
	
	private function handleKeyDown(e:KeyboardEvent):Void {
		if (e.keyCode == Keyboard.SPACE) reset();
	}
	
}
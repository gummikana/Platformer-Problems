package com.grapefrukt.games.platprob;

import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;
import nme.events.Event;
import nme.display.Sprite;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Game extends Sprite {

	private var world:B2World;
	private var physicsDebug:Sprite;
	
	public function new() {
		super();
	}
	
	public function init() {
		
		world = new B2World(new B2Vec2(0, 0.0), false);
		//contacts = new ContactListener();
		//world.setContactListener(contacts);
		//world.setContactFilter(new ContactFilter());
		
		physicsDebug = new Sprite();
		addChild(physicsDebug);
		
		var debugDraw = new B2DebugDraw();
		debugDraw.setSprite(physicsDebug);
		debugDraw.setDrawScale(1 / Settings.PHYSICS_SCALE);
		debugDraw.setFlags(B2DebugDraw.e_shapeBit | B2DebugDraw.e_jointBit);
		
		world.setDebugDraw(debugDraw);
		
		addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		
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
		createBox(Settings.STAGE_W / 2, Settings.STAGE_H + 50, Settings.STAGE_W, 100, false); // bottom
		createBox(Settings.STAGE_W / 2, -50, Settings.STAGE_W, 100, false); // top
		createBox(-50, Settings.STAGE_H / 2, 100, Settings.STAGE_H, false); // right
		createBox(Settings.STAGE_W+50, Settings.STAGE_H / 2, 100, Settings.STAGE_H, false); // left
		
	}
	
	public function handleEnterFrame(e:Event) {
		world.step(Settings.PHYSICS_STEP_DURATION, 10, 10);
		world.clearForces();
		world.drawDebugData();
	}
	
	private function createBox(x:Float, y:Float, width:Float, height:Float, dynamicBody:Bool = true, density:Float = 0):B2Body {
		var bodyDefinition = new B2BodyDef();
		bodyDefinition.position.set(x * Settings.PHYSICS_SCALE, y * Settings.PHYSICS_SCALE);
		
		if (dynamicBody) {
			bodyDefinition.type = B2Body.b2_dynamicBody;
		}
		
		var polygon = new B2PolygonShape();
		polygon.setAsBox((width / 2) * Settings.PHYSICS_SCALE, (height / 2) * Settings.PHYSICS_SCALE);
		
		var fixtureDefinition = new B2FixtureDef();
		fixtureDefinition.shape = polygon;
		fixtureDefinition.density = density;
		fixtureDefinition.friction = .5;
		fixtureDefinition.restitution = .5;
		
		if (!dynamicBody) {
			fixtureDefinition.friction = .05;
		}
		
		var body = world.createBody(bodyDefinition);
		body.createFixture(fixtureDefinition);
		
		return body;
	}
	
	private function createPill(x:Float, y:Float, radius:Float, length:Float, density:Float = 0):B2Body {
		var bodyDefinition = new B2BodyDef();
		bodyDefinition.position.set(x * Settings.PHYSICS_SCALE, y * Settings.PHYSICS_SCALE);
		bodyDefinition.type = B2Body.b2_dynamicBody;
		
		var box = new B2PolygonShape();
		box.setAsBox((radius - .3) * Settings.PHYSICS_SCALE, (length - radius * 2) * Settings.PHYSICS_SCALE);
		
		var circle = new B2CircleShape(radius * Settings.PHYSICS_SCALE);
		
		var fd = new B2FixtureDef();
		fd.density = density;
		fd.friction = .5;
		fd.restitution = .5;
		
		var body = world.createBody(bodyDefinition);
		
		fd.shape = box;
		body.createFixture(fd);
		
		fd.shape = circle;
		
		circle.setLocalPosition(Settings.psb2(0, -(length - radius * 2)));
		body.createFixture(fd);
		
		circle.setLocalPosition(Settings.psb2(0, (length - radius * 2)));
		body.createFixture(fd);
		
		return body;
	}
	
	private function createCircle(x:Float, y:Float, radius:Float, dynamicBody:Bool):B2Body {
		var bodyDefinition = new B2BodyDef();
		bodyDefinition.position.set(x * Settings.PHYSICS_SCALE, y * Settings.PHYSICS_SCALE);
		
		if (dynamicBody) {
			bodyDefinition.type = B2Body.b2_dynamicBody;
		}
		
		var circle = new B2CircleShape(radius * Settings.PHYSICS_SCALE);
		
		var fixtureDefinition = new B2FixtureDef();
		fixtureDefinition.shape = circle;
		
		var body = world.createBody(bodyDefinition);
		body.createFixture(fixtureDefinition);
		
		return body;
	}
	
}
package com.grapefrukt.games.platprob;
import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Utils {

	public static function createBox(world:B2World, x:Float, y:Float, width:Float, height:Float, dynamicBody:Bool = true, density:Float = 0):B2Body {
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
	
	public static function createPill(world:B2World, x:Float, y:Float, radius:Float, length:Float, density:Float = 0):B2Body {
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
	
	public static function createCircle(world:B2World, x:Float, y:Float, radius:Float, dynamicBody:Bool):B2Body {
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
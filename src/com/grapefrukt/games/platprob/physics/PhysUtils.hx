package com.grapefrukt.games.platprob.physics;
import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;
import com.grapefrukt.games.platprob.Settings;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class PhysUtils {
	
	public static function createBounds(world:B2World, friction:Float, restitution:Float) {
		PhysUtils.createBox(world, Settings.STAGE_W / 2, Settings.STAGE_H + 50, Settings.STAGE_W, 100, false, friction, restitution); // bottom
		PhysUtils.createBox(world, Settings.STAGE_W / 2, -50, Settings.STAGE_W, 100, false, friction, restitution); // top
		PhysUtils.createBox(world, -50, Settings.STAGE_H / 2, 100, Settings.STAGE_H, false, friction, restitution); // right
		PhysUtils.createBox(world, Settings.STAGE_W + 50, Settings.STAGE_H / 2, 100, Settings.STAGE_H, false, friction, restitution); // left
	}

	public static function createBox(world:B2World, x:Float, y:Float, width:Float, height:Float, dynamicBody:Bool = true, friction:Float = .5, restitution:Float = .5, density:Float = 0):B2Body {
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
		fixtureDefinition.friction = friction;
		fixtureDefinition.restitution = restitution;
		
		if (!dynamicBody) {
			fixtureDefinition.friction = friction;
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
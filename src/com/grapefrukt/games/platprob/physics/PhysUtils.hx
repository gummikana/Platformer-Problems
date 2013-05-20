package com.grapefrukt.games.platprob.physics;
import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;
import box2D.common.math.B2Vec2;
import box2D.dynamics.joints.B2RevoluteJointDef;
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
	public static function createBoxInMeters(world:B2World, x:Float, y:Float, width_m:Float, height_m:Float, dynamicBody:Bool = true, friction:Float = .5, restitution:Float = .5, density:Float = 0):B2Body {
		var bodyDefinition = new B2BodyDef();
		bodyDefinition.position.set(x, y);
		
		if (dynamicBody) {
			bodyDefinition.type = B2Body.b2_dynamicBody;
		}
		
		var polygon = new B2PolygonShape();
		polygon.setAsBox((width_m / 2) , (height_m / 2) );
		
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
	
	public static function createPlayerInMeters(world:B2World, x:Float, y:Float, width_m:Float, height_m:Float, dynamicBody:Bool = true, friction:Float = .5, restitution:Float = .5, density:Float = 0):Array< B2Body > {
		var result:Array< B2Body > = [];
		
		/*var bodyDefinition = new B2BodyDef();
		bodyDefinition.position.set(x, y);
		
		if (dynamicBody) {
			bodyDefinition.type = B2Body.b2_dynamicBody;
		}
		
		var polygon = new B2PolygonShape();
		polygon.setAsBox((width_m / 2) , (height_m / 2) );
		
		var fixtureDefinition = new B2FixtureDef();
		fixtureDefinition.shape = polygon;
		fixtureDefinition.density = density;
		fixtureDefinition.friction = 0;
		fixtureDefinition.restitution = restitution;
		
		if (!dynamicBody) {
			fixtureDefinition.friction = friction;
		}
		
		var body = world.createBody(bodyDefinition);
		body.createFixture(fixtureDefinition);*/
		
		var body = createPill( world, x / Settings.PHYSICS_SCALE, y / Settings.PHYSICS_SCALE, ( width_m * 0.5 ) / Settings.PHYSICS_SCALE, height_m /  Settings.PHYSICS_SCALE, density, 0, restitution );
		
		// wheel 
		var wheelDefinition = new B2BodyDef();
		wheelDefinition.position.set(x, y + height_m * 0.5 + 0.05 );
		
		if (dynamicBody) {
			wheelDefinition.type = B2Body.b2_dynamicBody;
		}
		
		var circle = new B2CircleShape( width_m * 0.5 - 0.05 );
		
		var fixtureDefinition = new B2FixtureDef();
		fixtureDefinition.shape = circle;
		fixtureDefinition.density = density;
		fixtureDefinition.friction = friction;
		fixtureDefinition.restitution = restitution;
		
		var wheel = world.createBody(wheelDefinition);
		wheel.createFixture(fixtureDefinition);
		
		var jointDef = new B2RevoluteJointDef();
		jointDef.initialize( body, wheel, new B2Vec2( x, y + height_m * 0.5 + 0.05 ) );
		
		var joint = world.createJoint( jointDef );

		result.push( body );
		result.push( wheel );
		
		return result;
	}

	
	public static function createPill(world:B2World, x:Float, y:Float, radius:Float, length:Float, density:Float = 0, friction:Float = 0.1, restitution:Float = 0.1):B2Body {
		var bodyDefinition = new B2BodyDef();
		bodyDefinition.position.set(x * Settings.PHYSICS_SCALE, y * Settings.PHYSICS_SCALE);
		bodyDefinition.type = B2Body.b2_dynamicBody;
		
		var box = new B2PolygonShape();
		box.setAsBox((radius - .3) * Settings.PHYSICS_SCALE, (length - radius * 2) * Settings.PHYSICS_SCALE);
		
		var circle = new B2CircleShape(radius * Settings.PHYSICS_SCALE);
		
		var fd = new B2FixtureDef();
		fd.density = density;
		fd.friction = friction;
		fd.restitution = restitution;
		
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
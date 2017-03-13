package com.grapefrukt.games.platprob;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2World;
import box2D.dynamics.B2Body;
import com.grapefrukt.games.platprob.physics.ContactFilter;
import com.grapefrukt.games.platprob.physics.ContactListener;
import com.grapefrukt.games.platprob.physics.PhysUtils;
import com.grapefrukt.utils.KeyInputUtil;
import com.grapefrukt.utils.SettingsLoader;
import com.grapefrukt.utils.Shaker;
import com.grapefrukt.utils.Timestep;
import com.grapefrukt.utils.Toggler;
import net.hires.debug.Stats;
import openfl.Assets;
import flash.display.Sprite;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.ui.Keyboard;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Game extends Sprite {
	
	private var world:B2World;
	private var canvas:Sprite;
	private var input:KeyInputUtil;
	private var player:IPlayer;
	private var toggler:Toggler;
	private var settingsLoader:SettingsLoader;
	private var debugDraw:B2DebugDraw;
	private var time:Timestep;
	private var acc:Float = 0;
	private var text:TextField;
	private var gui:MovieClip;
	private var txt:TextField;
	
	public function new() {
		super();
	}
	
	public function init() {
		toggler = new Toggler(Settings, false, reset);
		Lib.current.addChild(toggler);
		
		Lib.current.addChild(new Stats());
		
		text = new TextField();
		text.selectable = false;
		text.mouseEnabled = false;
		Lib.current.addChild(text);
		
		settingsLoader = new SettingsLoader("config/config.cfg", Settings);
		settingsLoader.addEventListener(Event.COMPLETE, function(e:Event) {
			toggler.reset();
			reset();
		});
		
		time = new Timestep(60, 1 / 60);
		
		canvas = new Sprite();
		addChild(canvas);
		
		debugDraw = new B2DebugDraw();
		debugDraw.setSprite(canvas);
		debugDraw.setDrawScale(1 / Settings.PHYSICS_SCALE);
		debugDraw.setFlags(B2DebugDraw.e_shapeBit | B2DebugDraw.e_jointBit);
		debugDraw.setFillAlpha(1);
		debugDraw.setLineThickness(0);
		
		input = new KeyInputUtil(stage);
		input.map(Keyboard.LEFT, Input.LEFT);
		input.map(Keyboard.RIGHT, Input.RIGHT);
		input.map(Keyboard.UP, Input.JUMP);
		input.map(Keyboard.Z, Input.JUMP);
		
		Shaker.init(this);
		
		addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		
		reset();
		
		//gui = getClip("ArrowKeysGfx");
		gui = new MovieClip();
		gui.x = Settings.STAGE_W;
		gui.y = Settings.STAGE_H;
		addChild(gui);
		
		txt = FontSettings.getDefaultTextField(72, 0xB6D29C, 300);
		FontSettings.setAlign(txt, TextFormatAlign.RIGHT);
		txt.autoSize = TextFieldAutoSize.RIGHT;
		txt.text = "";
		txt.x = -55 - 300;
		txt.y = -270;
		gui.addChild(txt);
		
	}
	
	public function reset() {
		if (world != null) PhysUtils.destroyWorld(world);
		
		world = new B2World(new B2Vec2(0, Settings.PHYSICS_GRAVITY ), false);
		world.setContactListener(new ContactListener());
		world.setContactFilter(new ContactFilter());
		world.setDebugDraw(debugDraw);
		
		Level.load(world, "level");
		
		if ( Settings.VPLAYER_IN_USE == true )
			player = new PlayerVelocity( world );
		else
			player = new Player(world);
	}

	
	public function handleEnterFrame(e:Event) {
		time.tick();
		
		var g = world.getGravity();
		g.y = Settings.PHYSICS_GRAVITY;
		world.setGravity(g);
	
		acc += time.timeDelta;
		var numSteps = 0;
		while (acc - Settings.PHYSICS_STEP_DURATION > 0) {
			world.step(Settings.PHYSICS_STEP_DURATION, 10, 10);
			world.clearForces();
			
			acc -= Settings.PHYSICS_STEP_DURATION;
			numSteps++;
			
			if (numSteps > 8) {
				acc = 0;
				Lib.trace("update taking too long, bailing");
				break;
			}
		}
		
		text.text = numSteps + " " + time.timeDelta;
		
		if( numSteps != 0 ) {
			world.drawDebugData();
		
			Shaker.update(time.timeDelta);

			for ( i in 0...numSteps ) {

				// playerBody.applyForce( new B2Vec2( 0, -100 ), new B2Vec2() );
				if ( player.isOnGround && input.isDown(Input.JUMP, true) ) player.jump();
				if ( Settings.PLATFORMING_CLAMP_JUMP && !player.isOnGround && !input.isDown(Input.JUMP) ) player.stopJump();
				
				if ( input.isDown(Input.LEFT, false) ) player.applyHorizontalMove(  -1.0 );
				if ( input.isDown(Input.RIGHT, false) ) player.applyHorizontalMove(  1.0 );
				
				player.update(time.timeDelta);
			}
			var pos = player.body.getPosition().copy();
			var vel = player.body.getLinearVelocity().copy();
			// vel.x = 0;
			// vel.y = 0;
			pos.multiply(1 / Settings.PHYSICS_SCALE);
			canvas.x -= (canvas.x - (Settings.STAGE_W / 2 - pos.x - vel.x * Settings.CAMERA_VELOCITY_LEAD_X)) * Settings.CAMERA_SMOOTHING;
			canvas.y -= (canvas.y - (Settings.STAGE_H / 2 - pos.y - vel.y * Settings.CAMERA_VELOCITY_LEAD_Y)) * Settings.CAMERA_SMOOTHING;
		}
		
		//gui.getChildByName("left").visible = input.isDown(Input.LEFT);
		//gui.getChildByName("jump").visible = input.isDown(Input.JUMP);
		//gui.getChildByName("right").visible = input.isDown(Input.RIGHT);
		
		if (player.jumpTime > 0) {
			txt.text = Math.round( -player.jumpHeight / Settings.PLAYER_HEIGHT * 10) / 10 +"x\n" + Math.round(player.jumpTime / 10)*10 + "ms";
		} else {
			txt.text = "";
		}
	}
	
	private function handleKeyDown(e:KeyboardEvent):Void {
		if (e.keyCode == Keyboard.SPACE) reset();
		if (e.keyCode == Keyboard.S) Shaker.shakeRandom(20);
		if (e.keyCode == Keyboard.E) settingsLoader.export();
		if (e.keyCode == Keyboard.ESCAPE) {
			#if flash
				flash.system.System.exit(0);
			#else
				Lib.exit();
			#end
		}
	}
	
	public static function getClip(tag:String) {
		//if (SWF_DATA == null) SWF_DATA = new SWF(Assets.getBytes ("libraries/platformer.swf"));
		//return SWF_DATA.createMovieClip(tag);
		return Assets.getMovieClip ("platformer:" + tag);
	}
	
}
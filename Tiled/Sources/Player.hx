package;

import kha.Assets;
import sdg.Object;
import sdg.Sdg;
import sdg.atlas.Atlas;
import sdg.collision.Hitbox;
import sdg.graphics.Sprite;
import sdg.manager.Keyboard;
import sdg.atlas.Atlas;
import sdg.atlas.Region;
import sdg.components.Motion;
import sdg.components.Animator;

class Player extends Object
{
	var sprite:Sprite;	
	var motion:Motion;
	var animator:Animator;
	var onGround:Bool;
	
	var body:Hitbox;
	var halfWidth:Int;	

	public function new(x:Float, y:Float):Void
	{
		super(x, y);

		layer = 3;

		var regions = Atlas.createRegionsFromAsset(Assets.images.player, 92, 136);
		
		sprite = new Sprite(regions[0]);
		graphic = sprite;

		setSizeAuto();
		halfWidth = Std.int(width / 2);

		body = new Hitbox(this, 'play');
		
		setupAnimations(regions);
		
		motion = new Motion();
		motion.drag.x = 0.5;
		motion.maxVelocity.x = 5;
		motion.acceleration.y = 0.3;
		addComponent(motion);
		
		onGround = false;
	}

	function setupAnimations(regions:Array<Region>)
	{
		animator = new Animator();
		animator.addAnimation('idle', regions.slice(0, 10));
		animator.addAnimation('run', regions.slice(10, 20), 14);

		addComponent(animator);

		animator.play('idle');
	}

	override public function update():Void
	{
		super.update();

		motion.acceleration.x = 0;		

		if (Keyboard.isHeld('left'))
		{
			motion.acceleration.x = -0.7;
			sprite.flip.x = true;	
		}            
        else if (Keyboard.isHeld('right'))
		{		
			motion.acceleration.x = 0.7;
			sprite.flip.x = false;
		}

		if (Keyboard.isPressed('z') && onGround)
		{
			motion.velocity.y = -9;
			onGround = false;
		}
		else if (Keyboard.isPressed('r'))
		{
			onGround = false;
			setPosition(70, 120);
		}

		if (motion.velocity.x != 0 && animator.nameAnim != 'run')			
			animator.play('run');					
		else if (motion.velocity.x == 0 && animator.nameAnim != 'idle')		
			animator.play('idle');		
		
		body.moveBy(motion.velocity.x, motion.velocity.y, 'collision');

		screen.camera.follow(x + halfWidth, 0);

		if (x < 0)
			x = 0
		else if (right > screen.worldWidth)
			x = screen.worldWidth - width;

		if (y > Sdg.gameHeight)
			y = -height;	
	}

	override public function moveCollideY(object:Object):Bool
	{
		if (motion.velocity.y > 0)
		{
			onGround = true;
			motion.velocity.y = 0;
		}

		return true;
	}	
}
package;

import kha.Color;
import kha.math.Vector2i;
import sdg.Object;
import sdg.Sdg;
import sdg.manager.Keyboard;
import sdg.components.Motion;
import sdg.graphics.shapes.Polygon;
import sdg.graphics.shapes.Circle;
import sdg.graphics.GraphicList;
import differ.Collision;
import differ.shapes.Shape;
import differ.shapes.Polygon as DifferPolygon;
import differ.shapes.Circle as DifferCircle;

class Player extends Object
{		
	var motion:Motion;	
	var onGround:Bool;		
	var shape1:DifferCircle;
	var shape2:DifferCircle;

	var halfSize:Vector2i;

	public function new(x:Float, y:Float):Void
	{
		super(x, y);

		var head = new Circle(15, Color.Red);		

		var body = Polygon.createRectangle(30, 30, Color.Red);
		body.y = 15;		

		var foot = new Circle(15, Color.Red);		
		foot.y = 30;
				
		graphic = new GraphicList([head, body, foot]);
		setSizeAuto();

		halfSize = new Vector2i(Std.int(width / 2), Std.int(height / 2));
		
		shape1 = new DifferCircle(x + 15, y + 15, 15);
		shape2 = new DifferCircle(x + 15, y + 45, 15);		
		
		motion = new Motion();
		motion.drag.x = 0.5;
		motion.maxVelocity.x = 5;
		motion.acceleration.y = 0.5;
		addComponent(motion);
		
		onGround = false;
	}

	override public function update():Void
	{
		super.update();

		motion.acceleration.x = 0;		

		if (Keyboard.isHeld('left'))		
			motion.acceleration.x = -0.7;
        else if (Keyboard.isHeld('right'))				
			motion.acceleration.x = 0.7;		

		if ((Keyboard.isPressed('z') || Keyboard.isPressed('up')) && onGround)
		{
			motion.velocity.y = -8;
			onGround = false;
		}
		else if (Keyboard.isPressed('r'))
		{
			onGround = false;
			setPosition(120, 120);
		}
		
		x += motion.velocity.x;
		y += motion.velocity.y;		

		setShape1Position();
		setShape2Position();

		if (checkCollision(shape1))
			setShape2Position();			

		checkCollision(shape2);

		screen.camera.follow(x + halfSize.x, y + halfSize.y);
	}

	inline function setShape1Position()
	{
		shape1.x = x + 15;
		shape1.y = y + 15;		
	}

	inline function setShape2Position()
	{
		shape2.x = x + 15;
		shape2.y = y + 45;
	}

	function checkCollision(shape:Shape):Bool
	{
		var collisionInfo = Collision.shapeWithShapes(shape, Play.instance.shapeList); 
		if (collisionInfo != null && collisionInfo.length > 0)
		{
			for (collision in collisionInfo)
			{
				x += collision.separationX;
				y += collision.separationY;
			}

			motion.velocity.y = 0;
			onGround = true;

			return true;
		}
		
		onGround = false;

		return false;
	}	
}
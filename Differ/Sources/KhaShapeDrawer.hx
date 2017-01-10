package;

import differ.ShapeDrawer;
import kha.graphics2.Graphics;
import sdg.Sdg;

class KhaShapeDrawer extends ShapeDrawer
{
	public static var g:Graphics;	

	public override function drawLine(p0x:Float, p0y:Float, p1x:Float, p1y:Float, ?startPoint:Bool = true) 
	{
		g.drawLine(p0x - Sdg.screen.camera.x, p0y - Sdg.screen.camera.y, p1x - Sdg.screen.camera.x, p1y - Sdg.screen.camera.y, 1);
    }
}
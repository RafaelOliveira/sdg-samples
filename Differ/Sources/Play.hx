package;

import kha.Assets;
import sdg.Object;
import sdg.Screen;
import sdg.graphics.tiles.Tileset;
import sdg.graphics.tiles.Tilemap;
import sdg.graphics.TileSprite;
import format.tmx.Reader;
import format.tmx.Data.TmxTileLayer;
import format.tmx.Data.TmxObject;
import format.tmx.Data.TmxObjectGroup;
import format.tmx.Tools;
import differ.shapes.Shape;
import differ.shapes.Polygon;
import differ.Collision;
import differ.math.Vector;

class Play extends Screen
{
	public var shapeList:Array<Shape>;

	public static var instance:Play;

	public function new()
	{
		super();

		instance = this;
		
		var bg = new Object();
		add(bg);

		add(new Player(100, 100));
		
		loadMap();		

		bg.graphic = new TileSprite(Assets.images.bg, worldWidth, worldHeight);
	}

	inline function loadMap()
	{
		var reader = new Reader(Xml.parse(Assets.blobs.map_tmx.toString()));
		var tmxMap = reader.read();		

		var tileset = new Tileset(Assets.images.tileset, 86, 86);
		var bgMap = new Tilemap(tileset);

		// the object of the tilemap
		var objectMap = new Object();

		for (layer in tmxMap.layers)
		{
			switch(layer)
			{
				case TileLayer(layer):
					if (layer.name == 'tile_collision')
					{
						var data = new Array<Array<Int>>();
						var i = 0;

						for (y in 0...layer.height)
						{
							data.push(new Array<Int>());

							for (x in 0...layer.width)
							{
								data[y].push(layer.data.tiles[i].gid - 1);
								i++;
							}							
						}

						bgMap.loadFrom2DArray(data);
						objectMap.graphic = bgMap;
						objectMap.setSizeAuto();

						// adjust the size of the world
						// to the size of the map
						worldWidth = bgMap.widthInPixels;
						worldHeight = bgMap.heightInPixels;

						add(objectMap);
					}

				case ObjectGroup(group):
					if (group.name == 'objects_collision')
					{
						shapeList = new Array<Shape>();

						for (object in group.objects)
						{
							switch(object.objectType)
							{
								case Rectangle:
									shapeList.push(Polygon.rectangle(objectMap.x + object.x, objectMap.y + object.y, 
										object.width, object.height, false));

								case Polygon(points):
									var vertices = new Array<Vector>();

									for (p in points)
										vertices.push(new Vector(p.x, p.y));

									shapeList.push(new Polygon(objectMap.x + object.x, objectMap.y + object.y, vertices));

								default: continue;
							}
						}
					}
		
				default: continue;
			}
		}		
	}
}
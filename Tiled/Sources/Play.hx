package;

import kha.Assets;
import sdg.Object;
import sdg.Screen;
import sdg.Sdg;
import sdg.graphics.Sprite;
import sdg.graphics.tiles.Tileset;
import sdg.graphics.tiles.Tilemap;
import sdg.graphics.TileSprite;
import sdg.collision.Hitbox;
import sdg.collision.Grid;
import sdg.math.Rectangle;
import sdg.atlas.Atlas;
import sdg.atlas.Region;
import format.tmx.Reader;
import format.tmx.Data.TmxTileLayer;
import format.tmx.Data.TmxObject;
import format.tmx.Data.TmxObjectGroup;
import format.tmx.Tools;
import Player;

/*
	Rendering order

	These are the values of the layers
	to put everything in the right Order.
	Layers with higher values are rendered first. 

	0 objects_fg
	1 tilemap
	2 water
	3 player, objects_collision
	4 bg, objects_bg
*/

class Play extends Screen
{
	public function new()
	{
		super();

		var bg = create(0, 0, new Sprite(Assets.images.bg));
		bg.layer = 4;
		bg.fixed.x = true;

		var water = create(355, 560, new TileSprite('Water', 316, 54, 1, 0));
		water.layer = 2;
		
		loadMap();

		add(new Player(70, 120));
	}

	inline function loadMap()
	{
		var reader = new Reader(Xml.parse(Assets.blobs.map_tmx.toString()));
		var tmxMap = reader.read();

		Tools.fixObjectPlacement(tmxMap);

		var tileset = new Tileset('tileset', 128, 128);
		var bgMap = new Tilemap(tileset);
		
		// a list of regions from the atlas cache
		// that matches the ids of the objects in the map file
		var regions = new Map<Int, Region>();

		// the object of the tilemap
		var objectMap = new Object();
		objectMap.layer = 1;
		
		for (tmxTileset in tmxMap.tilesets)
		{
			if (tmxTileset.name == 'objects')
			{
				var gid = tmxTileset.firstGID;
				
				for (tile in tmxTileset.tiles)
				{
					// get the name of the images without the path and extension
					// like the name of the regions in the atlas
					var name = tile.image.source;
					name = StringTools.replace(name, 'images/', '');
					name = StringTools.replace(name, '.png', '');

					regions.set(gid + tile.id, Atlas.getRegion(name));
				}				
			}
		}

		for (layer in tmxMap.layers)
		{
			switch(layer)
			{
				case TileLayer(layer):
					if (layer.name == 'collision')
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
					switch(group.name)
					{
						case 'objects_bg': 			createObjects(group.objects, regions, false, 4);						
						case 'objects_collision':	createObjects(group.objects, regions, true, 3);
						case 'objects_fg':			createObjects(group.objects, regions, false, 0);
					}
		
				default: continue;
			}
		}

		var grid = new Grid(objectMap, 128, 128, 'collision');
				 
		grid.setArea(0, 4, 3, 1, true);
		grid.setArea(5, 4, 10, 1, true);
		grid.setArea(7, 3, 2, 1, true);

		// this is a rect for the floating platforms
		// because the height is smaller		
		var rectTile = new Rectangle(0, 0, 128, 66);
		
		// first platform
		grid.setColRect(2, 1, rectTile);
		grid.setColRect(3, 1, rectTile);
		grid.setColRect(4, 1, rectTile);

		// second platform
		grid.setColRect(10, 1, rectTile);
		grid.setColRect(11, 1, rectTile);
	}

	function createObjects(objects:Array<TmxObject>, regions:Map<Int, Region>, collision:Bool, layer:Int)
	{
		for (object in objects)
		{
			switch(object.objectType)
			{
				case Tile(gid):
					var obj = create(object.x, object.y, new Sprite(regions.get(gid)));
					obj.setSizeAuto();
										
					obj.layer = layer;
					
					if (collision)
						new Hitbox(obj, null, 'collision');

				default: continue;
			}
		}
	}
}
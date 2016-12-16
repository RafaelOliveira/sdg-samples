package;

import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import sdg.Engine;
import sdg.manager.Keyboard;
import sdg.atlas.Atlas;
import sdg.collision.Hitbox;
import sdg.Sdg;

class Project 
{
	public function new() 
	{
		Assets.loadEverything(assetsLoaded);		
	}

	function assetsLoaded()
	{
		var engine = new Engine(800, 600);
		engine.addManager(new Keyboard());

		Atlas.loadAtlasShoebox(Assets.images.textures, Assets.blobs.textures_xml);

		// Initializes the collision system
		Hitbox.init();

		Sdg.addScreen('play', new Play(), true);

		System.notifyOnRender(engine.render);
		Scheduler.addTimeTask(engine.update, 0, 1 / 60);
	}
}
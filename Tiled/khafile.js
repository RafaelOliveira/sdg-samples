let project = new Project('Tiled');
project.addAssets('Assets/**');
project.addSources('Sources');
project.addLibrary('Sdg');
project.addLibrary('format-tiled');
project.windowOptions.width = 800;
project.windowOptions.height = 600;
resolve(project);

let project = new Project('Differ');
project.addAssets('Assets/**');
project.addSources('Sources');
project.addLibrary('Sdg');
project.addLibrary('format-tiled');
project.addLibrary('differ');
project.windowOptions.width = 800;
project.windowOptions.height = 600;
resolve(project);
let project = new Project('Tiled');
project.addAssets('Assets/**');
project.addSources('Sources');
project.addLibrary('Sdg');
project.addLibrary('format-tiled');
resolve(project);

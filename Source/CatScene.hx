package;

import openfl.display.Sprite;
import openfl.Assets;

class CatScene extends Scene {

  public function new()
  {
    super();
  }

  override public function onSceneEnter():Void
  {
    redraw();

    SceneManager.pushSubScene(new Popup("Hello!"), false);
  }

  override public function onSceneResize():Void
  {
    super.onSceneResize();

    if (isCurrentScene())
      redraw();
    else
    {
      if (numChildren > 0)
        removeChildren(0, numChildren - 1);
    }
  }

  private function redraw():Void
  {
    if (numChildren > 0)
      removeChildren(0, numChildren - 1);

    var sw = SceneManager.getWidth();
    var sh = SceneManager.getHeight();
    var df = SceneManager.getDisplayFactor();

    var cat = Assets.getMovieClip("library:NyanCatAnimation");
    addChild(cat);

    cat.width = df;
    cat.height = df;
    cat.x = sw / 2 - cat.width / 2;
    cat.y = sh / 2 - cat.height / 2;
  }

}
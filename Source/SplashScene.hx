package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.Assets;

class SplashScene extends Scene {

  public function new()
  {
    super();
  }

  override public function onSceneEnter():Void
  {
    redraw();
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
  }

  override public function onMouseUp(event:MouseEvent):Void
  {
    SceneManager.setCurrentScene(GAME);
  }

}
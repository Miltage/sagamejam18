package;

import openfl.events.Event;
import openfl.events.MouseEvent;

class SubScene extends Scene {

  public function new()
  {
    super();
    addEventListener(MouseEvent.CLICK, onInput);
  }

  override public function onSceneEnter():Void
  {
    onSceneResize();
  }

  private function onInput(event:Event = null):Void
  {
    // nop
  }

  override public function onSceneResize():Void
  {
    super.onSceneResize();
    redraw();
  }

  public function redraw():Void
  {
    if (numChildren > 0)
      removeChildren(0, numChildren - 1);

    var sw = SceneManager.getWidth();
    var sh = SceneManager.getHeight();

    graphics.clear();
    graphics.beginFill(SceneManager.BACKGROUND_COLOR, 0.8);
    graphics.drawRect(0, 0, sw, sh);
  }

}
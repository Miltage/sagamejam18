package;

import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;

class Scene extends Sprite {

  public function new()
  {
    super();

    var sw = SceneManager.getWidth();
    var sh = SceneManager.getHeight();
    scrollRect = new Rectangle(0, 0, sw, sh);
  }

  public function onSceneEnter():Void
  {
    // override this
  }

  public function onSceneLeave():Void
  {
    // override this
  }

  public function onSceneResize():Void
  {
    var sw = SceneManager.getWidth();
    var sh = SceneManager.getHeight();
    scrollRect = new Rectangle(0, 0, sw, sh);
  }

  public function isCurrentScene():Bool
  {
    return SceneManager.getCurrentScene() == this;
  }

  public function onEnterFrame(event:Event, timeDelta:Float):Void
  {
    // override this
  }

  public function onExitFrame(event:Event):Void
  {
    // override this
  }

  public function handleFramesWithSubScene():Bool
  {
    return false;
  }

  public function onMouseDown(event:MouseEvent):Void
  {
    // override this
  }

  public function onMouseMove(event:MouseEvent):Void
  {
    // override this
  }

  public function onMouseUp(event:MouseEvent):Void
  {
    // override this
  }

  public function onKeyDown(event:KeyboardEvent):Void
  {
    // override this
  }

  public function onKeyUp(event:KeyboardEvent):Void
  {
    // override this
  }

  public function onDeactivate(event:Event):Void
  {
    // override this
  }

}
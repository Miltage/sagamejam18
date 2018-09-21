package;

import openfl.display.Sprite;

class GameScene extends Scene {

  private var level:Level;

  private var levelSprite:Sprite;

  public function new()
  {
    super();

    level = Level.getLevel(1);
  }

  override public function onSceneEnter():Void
  {
    onSceneResize();
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
    var df = SceneManager.getDisplayFactor();

    levelSprite = new Sprite();
    addChild(levelSprite);

    levelSprite.graphics.lineStyle(2, 0xFF0000, 1);
    levelSprite.graphics.beginFill(0xFF0000, 0.5);

    for (platform in level.getPlatforms())
    {
      levelSprite.graphics.drawRect(platform.x * df, platform.y * df, platform.width * df, platform.height * df);
    }
  }
  
}
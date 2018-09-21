package;

import openfl.display.Sprite;
import openfl.events.Event;

class GameScene extends Scene {

  public static inline var SPAWN_DELAY:Int = 100;

  private var level:Level;
  private var people:Array<Person>;

  private var levelSprite:Sprite;

  public function new()
  {
    super();

    level = Level.getLevel(1);
    people = new Array<Person>();

    var person:Person = new Person();
    people.push(person);
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

  override public function onEnterFrame(event:Event, timeDelta:Float):Void
  {
    doPhysicsUpdate(timeDelta);
  }

  private function doPhysicsUpdate(timeDelta:Float):Void
  {
    var df = SceneManager.getDisplayFactor();

    for (person in people)
    {
      for (platform in level.getPlatforms())
        if (person.collidesWith(platform))
          person.resolveCollision(platform);
        
      person.update(timeDelta);
    }
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
      #if debug
      levelSprite.graphics.drawRect(platform.x * df, platform.y * df, platform.width * df, platform.height * df);
      #end
    }

    for (person in people)
    {
      addChild(person);
    }
  }
  
}
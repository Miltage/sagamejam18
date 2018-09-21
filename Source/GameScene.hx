package;

import openfl.geom.Point;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;

class GameScene extends Scene {

  public static inline var SPAWN_DELAY:Float = 3;

  private var level:Level;
  private var people:Array<Person>;
  private var escalators:Array<Escalator>;

  private var levelSprite:Sprite;

  private var lastSpawn:Float;
  private var elapsedTime:Float;
  private var mousePressed:Bool;
  private var mousePoint:Point;
  private var activeEscalator:Escalator;

  public function new()
  {
    super();

    level = Level.getLevel(1);
    people = new Array<Person>();
    escalators = new Array<Escalator>();

    lastSpawn = 0;
    elapsedTime = 0;
    mousePressed = false;
    activeEscalator = null;
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
    elapsedTime += timeDelta;
    if (elapsedTime - lastSpawn > SPAWN_DELAY)
    {
      var person:Person = new Person();
      addChild(person);
      people.push(person);
      lastSpawn = elapsedTime;
    }

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

  override public function onMouseDown(event:MouseEvent):Void
  {
    mousePressed = true;
    mousePoint = new Point(mouseX, mouseY);

    var escalator = new Escalator(mouseX, mouseY);
    addChild(escalator);
    activeEscalator = escalator;
  }

  override public function onMouseUp(event:MouseEvent):Void
  {
    mousePressed = false;
    activeEscalator = null;
  }

  override public function onMouseMove(event:MouseEvent):Void
  {
    if (mousePressed && activeEscalator != null)
    {
      activeEscalator.setEnd(mouseX, mouseY);
      activeEscalator.redraw();
    }
  }
  
}
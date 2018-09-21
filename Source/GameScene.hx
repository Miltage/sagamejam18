package;

import openfl.geom.Point;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;

import haxe.Timer;

class GameScene extends Scene {

  public static inline var SPAWN_DELAY:Float = 3;
  public static inline var SCROLL_SPEED:Float = 0.5;

  private var level:Level;
  private var people:Array<Person>;
  private var escalators:Array<Escalator>;

  private var levelSprite:Sprite;

  private var lastSpawn:Float;
  private var elapsedTime:Float;
  private var mousePressed:Bool;
  private var mousePoint:Point;
  private var pan:Point;
  private var activeEscalator:Escalator;
  private var keyPresses:Map<Int, Float>;

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
    pan = new Point();
    keyPresses = new Map<Int, Float>();
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
    var df = SceneManager.getDisplayFactor();

    elapsedTime += timeDelta;
    if (elapsedTime - lastSpawn > SPAWN_DELAY)
    {
      var person:Person = new Person();
      levelSprite.addChild(person);
      people.push(person);
      person.setPosition(level.getEntrance());
      lastSpawn = elapsedTime;
    }

    if (keyPresses.exists('A'.code))
      pan.x += SCROLL_SPEED * df * timeDelta;
    else if (keyPresses.exists('D'.code))
      pan.x += -SCROLL_SPEED * df * timeDelta;

    if (keyPresses.exists('W'.code))
      pan.y += SCROLL_SPEED * df * timeDelta;
    else if (keyPresses.exists('S'.code))
      pan.y += -SCROLL_SPEED * df * timeDelta;

    levelSprite.x = pan.x;
    levelSprite.y = pan.y;

    doPhysicsUpdate(timeDelta);
  }

  private function doPhysicsUpdate(timeDelta:Float):Void
  {
    var df = SceneManager.getDisplayFactor();

    for (person in people)
    {
      for (platform in level.getPlatforms())
        if (person.collidesWithPlatform(platform))
          person.resolveCollision(platform);

      for (escalator in escalators)
        if (person.collidesWithEscalator(escalator) && !person.isRiding())
          person.rideEscalator(escalator);

      person.update(timeDelta);

      for (platform in level.getPlatforms())
        if (person.collidesWithPlatform(platform))
          person.resolveCollision(platform);

      if (person.collidesWithExit(level.getExit()))
      {
        people.remove(person);
        levelSprite.removeChild(person);
      }
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

    #if debug
      levelSprite.graphics.lineStyle(2, 0x33FF33, 1);
      levelSprite.graphics.beginFill(0x33FF33, 0.5);
      levelSprite.graphics.drawRect((level.getEntrance().x - 0.05) * df, (level.getEntrance().y - 0.05) * df, 0.1 * df, 0.1 * df);

      levelSprite.graphics.lineStyle(2, 0x3333FF, 1);
      levelSprite.graphics.beginFill(0x3333FF, 0.5);
      levelSprite.graphics.drawRect((level.getExit().x - 0.05) * df, (level.getExit().y - 0.05) * df, 0.1 * df, 0.1 * df);
    #end

    for (person in people)
    {
      levelSprite.addChild(person);
      person.redraw();
    }

    for (escalator in escalators)
    {
      levelSprite.addChild(escalator);
      escalator.redraw();
    }
  }

  override public function onMouseDown(event:MouseEvent):Void
  {
    mousePressed = true;
    mousePoint = new Point(mouseX, mouseY);

    var escalator = new Escalator(mouseX - pan.x, mouseY - pan.y);
    escalators.push(escalator);
    activeEscalator = escalator;
    redraw();
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
      activeEscalator.setEnd(mouseX - pan.x, mouseY - pan.y);
      activeEscalator.redraw();
    }
  }

  override public function onKeyDown(event:KeyboardEvent):Void
  {
    var now = Timer.stamp();
    keyPresses.set(Std.int(event.keyCode), now);
  }

  override public function onKeyUp(event:KeyboardEvent):Void
  {
    keyPresses.remove(Std.int(event.keyCode));
  }
  
}
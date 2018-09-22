package;

import openfl.geom.Point;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;

import haxe.Timer;

class GameScene extends Scene {

  public static inline var SPAWN_DELAY:Float = 3;
  public static inline var SPAWN_TOTAL:Float = 5;
  public static inline var SCROLL_SPEED:Float = 0.65;
  public static inline var PLACE_DIST:Float = 0.2;

  private var level:Level;
  private var people:Array<Person>;
  private var escalators:Array<Escalator>;

  private var levelSprite:Sprite;

  private var lastSpawn:Float;
  private var numSpawned:Float;
  private var numFinished:Float;
  private var elapsedTime:Float;
  private var mousePressed:Bool;
  private var mousePoint:Point;
  private var pan:Point;
  private var activeEscalator:Escalator;
  private var ghostEscalator:Escalator;
  private var keyPresses:Map<Int, Float>;

  public function new()
  {
    super();

    startLevel(1);
  }

  private function startLevel(number:Int):Void
  {
    level = Level.getLevel(number);
    people = new Array<Person>();
    escalators = new Array<Escalator>();

    lastSpawn = 0;
    elapsedTime = 0;
    numSpawned = 0;
    numFinished = 0;
    mousePressed = false;
    activeEscalator = null;

    pan = new Point();
    keyPresses = new Map<Int, Float>();
    onSceneResize();

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
    if (elapsedTime - lastSpawn > SPAWN_DELAY && numSpawned < SPAWN_TOTAL)
    {
      var person:Person = new Person();
      levelSprite.addChild(person);
      people.push(person);
      person.setPosition(level.getEntrance());
      lastSpawn = elapsedTime;
      numSpawned++;
    }

    if (keyPresses.exists('A'.code) || keyPresses.exists(37))
      pan.x += SCROLL_SPEED * df * timeDelta;
    else if (keyPresses.exists('D'.code) || keyPresses.exists(39))
      pan.x += -SCROLL_SPEED * df * timeDelta;

    if (keyPresses.exists('W'.code) || keyPresses.exists(38))
      pan.y += SCROLL_SPEED * df * timeDelta;
    else if (keyPresses.exists('S'.code) || keyPresses.exists(40))
      pan.y += -SCROLL_SPEED * df * timeDelta;

    levelSprite.x = pan.x;
    levelSprite.y = pan.y;

    doPhysicsUpdate(timeDelta);

    // check for win
    if (people.length == 0 && numSpawned == SPAWN_TOTAL)
    {
      if (numFinished >= Math.round(SPAWN_TOTAL * 0.8))
        SceneManager.pushSubScene(new Popup("Win!", function()
          {
            startLevel(level.getNumber() + 1);
          }));
      else
        SceneManager.pushSubScene(new Popup("Lose!", function()
          {
            startLevel(level.getNumber());
          }));
    }

    // ghost escalator
    var m = new Point((mouseX - pan.x) / df, (mouseY - pan.y) / df);
    var p = level.getPlatformAt(m);
    if (p != null && !mousePressed)
    {
      ghostEscalator.visible = m.x > p.x && m.x < p.x + p.width && m.y > p.y - PLACE_DIST && m.y < p.y + PLACE_DIST;
      ghostEscalator.setStart(m.x, p.y);
      ghostEscalator.setStartingPlatform(p);
      ghostEscalator.redraw();
    }
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
        numFinished++;
      }

      if (person.y > SceneManager.getHeight() * 2)
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

    ghostEscalator = new Escalator();
    ghostEscalator.visible = false;
    ghostEscalator.alpha = 0.2;
    ghostEscalator.redraw();
    levelSprite.addChild(ghostEscalator);
  }

  override public function onMouseDown(event:MouseEvent):Void
  {
    mousePressed = true;
    mousePoint = new Point(mouseX, mouseY);
  }

  override public function onMouseUp(event:MouseEvent):Void
  {
    mousePressed = false;
    ghostEscalator.visible = false;

    if (ghostEscalator.isClamped())
    {
      var escalator = new Escalator();
      escalator.setStart(ghostEscalator.getStart().x, ghostEscalator.getStart().y);
      escalator.setEnd(ghostEscalator.getEnd().x, ghostEscalator.getEnd().y);
      escalators.push(escalator);
    }
    
    redraw();
  }

  override public function onMouseMove(event:MouseEvent):Void
  {
    if (mousePressed && ghostEscalator.visible)
    {
      var df = SceneManager.getDisplayFactor();
      var m = new Point((mouseX - pan.x) / df, (mouseY - pan.y) / df);
      var p = level.getPlatformAt(m);
      if (p != null && ghostEscalator.getStartingPlatform() != p && level.getPlatformAt(ghostEscalator.getClampedEnd(m, p)) != null)
      {
        ghostEscalator.clampEndToPlatform(m, p);
      }
      else
      {
        ghostEscalator.setEnd(m.x, m.y);
      }
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
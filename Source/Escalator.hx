package;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.Sprite;

class Escalator extends Sprite {

  public static inline var ANGLE:Float = 0.5;
  
  private var start:Point;
  private var end:Point;
  private var direction:Point;
  private var startingPlatform:Rectangle;
  private var clamped:Bool;

  public function new(x:Float = 0.0, y:Float = 0.0)
  {
    super();

    start = new Point(x, y);
    end = null;
    direction = new Point();
    clamped = false;

    redraw();
  }

  public function redraw():Void
  {
    var df = SceneManager.getDisplayFactor();

    #if debug
    graphics.clear();
    graphics.lineStyle(2, 0x0000FF, 1);
    graphics.moveTo(start.x * df, start.y * df);
    if (end != null)
      graphics.lineTo(end.x * df, end.y * df);

    graphics.lineStyle(4, 0x0000FF, 1);
    graphics.moveTo(start.x * df, start.y * df);
    graphics.lineTo(start.x * df, (start.y - 0.1) * df);

    if (end != null)
    {
      graphics.moveTo(end.x * df, end.y * df);
      graphics.lineTo(end.x * df, (end.y - 0.1) * df);
    }
    #end
  }

  public function getStart():Point
  {
    return start;
  }

  public function getEnd():Point
  {
    return end;
  }

  public function getDirection():Point
  {
    return direction;
  }

  public function getAngle(length:Float):Point
  {
    return new Point(length * Math.cos(ANGLE) * direction.x, length * Math.sin(ANGLE) * direction.y);
  }

  public function setStart(x:Float, y:Float):Void
  {
    start = new Point(x, y);
  }

  public function getStartingPlatform():Rectangle
  {
    return startingPlatform;
  }

  public function setStartingPlatform(platform:Rectangle):Void
  {
    startingPlatform = platform;
  }

  public function setEnd(x:Float, y:Float):Void
  {
    var target = new Point(x, y);
    var len = Point.distance(start, target);

    if (end == null)
      end = new Point();

    var dx = 1;
    var dy = 1;
    if (target.y < start.y)
      dy = -1;
    if (target.x < start.x)
      dx = -1;

    direction = new Point(dx, dy);
    var angle = getAngle(len);

    end.x = start.x + angle.x;
    end.y = start.y + angle.y;
    clamped = false;
    redraw();
  }

  public function getClampedEnd(target:Point, platform:Rectangle):Point
  {
    var dx = 1;
    var dy = 1;
    if (target.y < start.y)
      dy = -1;
    if (target.x < start.x)
      dx = -1;

    direction = new Point(dx, dy);
    var p = getAngle(1);
    p.x += start.x;
    p.y += start.y;

    var a1 = p.y - start.y;
    var b1 = start.x - p.x;
    var c1 = a1 * start.x + b1 * start.y;

    var a2 = 0;
    var b2 = platform.width;
    var c2 = a2 * platform.x + b2 * platform.y;

    var delta = a1 * b2 - a2 * b1;
    return new Point((b2 * c1 - b1 * c2) / delta, (a1 * c2 - a2 * c1) / delta);
  }

  public function clampEndToPlatform(target:Point, platform:Rectangle):Void
  {
    end = getClampedEnd(target, platform);
    clamped = true;
    redraw();
  }

  public function isClamped():Bool
  {
    return clamped;
  }
}
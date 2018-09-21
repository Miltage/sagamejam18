package;

import openfl.geom.Point;
import openfl.display.Sprite;

class Escalator extends Sprite {

  public static inline var ANGLE:Float = 0.5;
  
  private var start:Point;
  private var end:Point;
  private var direction:Point;

  public function new(x:Float, y:Float)
  {
    super();

    var df = SceneManager.getDisplayFactor();

    start = new Point(x / df, y / df);
    end = new Point(start.x, start.y);
    direction = new Point();

    redraw();
  }

  public function redraw():Void
  {
    var df = SceneManager.getDisplayFactor();

    graphics.clear();
    graphics.lineStyle(2, 0x0000FF, 1);
    graphics.moveTo(start.x * df, start.y * df);
    graphics.lineTo(end.x * df, end.y * df);
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

  public function setEnd(x:Float, y:Float):Void
  {
    var df = SceneManager.getDisplayFactor();
    var target = new Point(x / df, y / df);
    var len = Point.distance(start, target);

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
    redraw();
  }
}
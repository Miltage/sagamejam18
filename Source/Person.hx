package;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.Sprite;

class Person extends Sprite {

  public static inline var MAX_MOVE_SPEED:Float = 0.12;
  public static inline var MOVE_SPEED:Float = 0.008;
  public static inline var MAX_FALL_SPEED:Float = 0.4;
  public static inline var FALL_SPEED:Float = 0.02;
  public static inline var RADIUS:Float = 0.05;

  private var velocity:Point;
  private var position:Point;
  private var grounded:Bool;
  private var moveSpeed:Float;
  private var fallSpeed:Float;

  private var escalator:Escalator;
  
  public function new()
  {
    super();

    grounded = false;
    moveSpeed = 0;
    fallSpeed = 0;
    velocity = new Point();
    position = new Point();

    redraw();
  }

  public function setPosition(pos:Point):Void
  {
    position.x = pos.x;
    position.y = pos.y;
  }

  public function redraw():Void
  {
    var df = SceneManager.getDisplayFactor();

    #if debug
    graphics.clear();
    graphics.lineStyle(2, 0xDEFEC8, 1);
    graphics.beginFill(0xDEFEC8, 0.5);
    graphics.drawCircle(0, 0, RADIUS * df);
    #end
  }

  public function update(timeDelta:Float):Void
  {
    var df = SceneManager.getDisplayFactor();

    if (isRiding())
    {
      velocity = escalator.getAngle(MAX_MOVE_SPEED * 0.75);

      if (Point.distance(position, escalator.getEnd()) < RADIUS)
        escalator = null;
    }
    else if (isGrounded())
    {
      velocity.y = 0;
      velocity.x += MOVE_SPEED;
    }
    else {
      velocity.y += FALL_SPEED;
      velocity.x *= 0.95;
    }

    position.x += velocity.x * timeDelta;
    position.y += velocity.y * timeDelta;
    grounded = false;

    if (velocity.x > 0)
      velocity.x = Math.min(velocity.x, MAX_MOVE_SPEED);
    else
      velocity.x = Math.max(-velocity.x, -MAX_MOVE_SPEED);
    velocity.y = Math.min(velocity.y, MAX_FALL_SPEED);

    x = Math.round(position.x * df);
    y = Math.round(position.y * df);
  }

  public function collidesWithPlatform(rect:Rectangle):Bool
  {
    if (isRiding())
      return false;

    var hw = rect.width/2;
    var hh = rect.height/2;
    var dx = Math.abs(position.x - rect.x - hw);
    var dy = Math.abs(position.y - rect.y - hh);

    if (dx > hw + RADIUS)
      return false;
    if (dy > hh + RADIUS)
      return false;

    if (dx <= hw)
      return true;
    if (dy <= hh)
      return true;

    var cd = (dx - hw)*(dx - hw) + (dy - hh)*(dy - hh);
    return cd <= RADIUS*RADIUS;
  }

  public function resolveCollision(rect:Rectangle):Void
  {
    var dx = position.x - rect.x + rect.width/2;
    var dy = position.y - rect.y + rect.height/2;
    if (dx < dy)
      position.x -= dx * RADIUS;
    else
      position.y -= dy * RADIUS;
    grounded = position.y < rect.y;
    velocity.y = 0;
  }

  public function collidesWithEscalator(escalator:Escalator):Bool
  {
    return Point.distance(position, escalator.getStart()) < RADIUS;
  }

  public function collidesWithExit(exit:Point):Bool
  {
    return Point.distance(position, exit) < RADIUS;
  }

  public function isRiding():Bool
  {
    return escalator != null;
  }

  public function rideEscalator(escalator:Escalator):Void
  {
    this.escalator = escalator;
    position.x = escalator.getStart().x;
    position.y = escalator.getStart().y - RADIUS;
  }

  public function setGrounded(grounded:Bool):Void
  {
    this.grounded = grounded;
  }

  public function isGrounded():Bool
  {
    return grounded;
  }

  public function getMoveSpeed():Float
  {
    return moveSpeed;
  }

  public function getFallSpeed():Float
  {
    return fallSpeed;
  }
}
package;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.Sprite;

class Person extends Sprite {

  public static inline var MAX_MOVE_SPEED:Float = 0.2;
  public static inline var MOVE_SPEED:Float = 0.008;
  public static inline var MAX_FALL_SPEED:Float = 0.4;
  public static inline var FALL_SPEED:Float = 0.02;
  public static inline var RADIUS:Float = 0.05;

  private var velocity:Point;
  private var position:Point;
  private var grounded:Bool;
  private var moveSpeed:Float;
  private var fallSpeed:Float;
  
  public function new()
  {
    super();

    var df = SceneManager.getDisplayFactor();

    grounded = false;
    moveSpeed = 0;
    fallSpeed = 0;
    velocity = new Point();
    position = new Point(0.5, 0);

    #if debug
    graphics.lineStyle(2, 0xDEFEC8, 1);
    graphics.beginFill(0xDEFEC8, 0.5);
    graphics.drawCircle(0, 0, RADIUS * df);
    #end
  }

  public function update(timeDelta:Float):Void
  {
    var df = SceneManager.getDisplayFactor();

    if (isGrounded())
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

  public function collidesWith(rect:Rectangle):Bool
  {
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
    position.y = rect.y - RADIUS;
    grounded = true;
    velocity.y = 0;
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
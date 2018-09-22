package;

import openfl.geom.Point;
import openfl.geom.Rectangle;

class Level {
  
  private var number:Int;
  private var platforms:List<Rectangle>;
  private var numPeople:Int;
  private var entrance:Point;
  private var exit:Point;

  public function new(n:Int)
  {
    number = n;

    platforms = new List();
    platformsPlease();
    setEntrance();
    setExit();
  }

  public function getNumber():Int
  {
    return number;
  }

  public function getEntrance():Point
  {
    return entrance;
  }

  public function getExit():Point
  {
    return exit;
  }

  public function setEntrance():Void
  {
    entrance = switch (number)
    {
      case 1: new Point(0.2, 0.35);
      default: new Point();
    }
  }

  public function setExit():Void
  {
    exit = switch (number)
    {
      case 1: new Point(1.4, 0.6);
      default: new Point();
    }
  }

  public function platformsPlease():Void
  {
    switch (number)
    {
      case 1:
        platforms.add(new Rectangle(0.1, 0.4, 1.5, 0.1));
        platforms.add(new Rectangle(0.1, 0.65, 1.7, 0.1));

      case 2:
        platforms.add(new Rectangle(0.4, 0.2, 0.5, 0.1));
    }
  }

  public function getPlatforms():List<Rectangle>
  {
    return platforms;
  }

  public function getClosestPlatform(point:Point):Rectangle
  {
    var dist:Float = 10000;
    var rect:Rectangle = null;
    for (platform in platforms)
    {
      var d = Point.distance(point, new Point(platform.x + platform.width/2, platform.y + platform.height/2));
      if (d < dist)
      {
        rect = platform;
        dist = d;
      }
    }
    return rect;
  }

  public function getPlatformAt(point:Point):Rectangle
  {
    for (platform in platforms)
    {
      if (point.x > platform.x && point.x < platform.x + platform.width && point.y > platform.y - GameScene.PLACE_DIST && point.y < platform.y + platform.height)
        return platform;
    }
    return null;
  }

  public static function getLevel(level:Int):Level
  {
    return new Level(level);
  }
}
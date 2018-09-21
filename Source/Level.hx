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
        platforms.add(new Rectangle(0.1, 0.4, 0.5, 0.1));
        platforms.add(new Rectangle(0.85, 0.65, 0.7, 0.1));
    }
  }

  public function getPlatforms():List<Rectangle>
  {
    return platforms;
  }

  public static function getLevel(level:Int):Level
  {
    return new Level(level);
  }
}
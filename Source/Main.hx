package;

import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.Lib;

class Main extends Sprite {
  
  
  public function new () {
    
    super();

    //SoundManager.init();

    var manager = new SceneManager();
    addChild(manager);

    resize();
    stage.addEventListener(Event.RESIZE, resize);
    
  }

  private function resize(event:Event = null):Void
  {
    var stage:Stage = Lib.current.stage;

    graphics.clear();
    graphics.beginFill(0x000000);
    graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
  }
  
  
}
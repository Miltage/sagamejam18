package;

import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
import haxe.Timer;

class PerfDebug extends TextField
{
  private var times:Array<Float>;
  private var memPeak:Float;

  public function new(inCol:Int = 0x000000)
  {
    super();

    defaultTextFormat = new TextFormat("_sans", 12, inCol);
    autoSize = TextFieldAutoSize.LEFT;
    selectable = false;

    mouseEnabled = false;

    times = [];
    memPeak = 0;
    addEventListener(Event.ENTER_FRAME, onEnter);
    onEnter();
  }

  private function onEnter(event:Event = null):Void
  {
    var now = Timer.stamp();
    times.push(now);

    while (times[0] < now - 1)
    {
      times.shift();
    }

    var mem:Float = Math.round(System.totalMemory / 1024 / 1024 * 100)/100;
    if (mem > memPeak)
      memPeak = mem;

    if (visible)
    {
      text = "FPS: " + times.length + "\nMEM: " + mem + " MB\nMEM peak: " + memPeak + " MB";
    }
  }
}

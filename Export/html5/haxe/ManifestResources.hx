package;


import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {
	
	
	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	
	
	public static function init (config:Dynamic):Void {
		
		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();
		
		var rootPath = null;
		
		if (config != null && Reflect.hasField (config, "rootPath")) {
			
			rootPath = Reflect.field (config, "rootPath");
			
		}
		
		if (rootPath == null) {
			
			#if (ios || tvos || emscripten)
			rootPath = "assets/";
			#elseif (sys && windows && !cs)
			rootPath = FileSystem.absolutePath (haxe.io.Path.directory (#if (haxe_ver >= 3.3) Sys.programPath () #else Sys.executablePath () #end)) + "/";
			#else
			rootPath = "";
			#end
			
		}
		
		Assets.defaultRootPath = rootPath;
		
		#if (openfl && !flash && !display)
		
		#end
		
		var data, manifest, library;
		
		#if kha
		
		null
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("null", library);
		
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("null");
		
		#else
		
		data = '{"name":"library","assets":"aoy4:pathy21:lib%2Flibrary%2F1.pngy4:sizei2460y4:typey5:IMAGEy2:idR1y7:preloadtgoR0y22:lib%2Flibrary%2F11.pngR2i2475R3R4R5R7R6tgoR0y22:lib%2Flibrary%2F13.pngR2i2486R3R4R5R8R6tgoR0y22:lib%2Flibrary%2F15.pngR2i2435R3R4R5R9R6tgoR0y22:lib%2Flibrary%2F17.pngR2i2445R3R4R5R10R6tgoR0y22:lib%2Flibrary%2F19.pngR2i2504R3R4R5R11R6tgoR0y22:lib%2Flibrary%2F21.pngR2i2466R3R4R5R12R6tgoR0y22:lib%2Flibrary%2F23.pngR2i2492R3R4R5R13R6tgoR0y21:lib%2Flibrary%2F3.pngR2i2443R3R4R5R14R6tgoR0y21:lib%2Flibrary%2F5.pngR2i2476R3R4R5R15R6tgoR0y21:lib%2Flibrary%2F7.pngR2i2478R3R4R5R16R6tgoR0y21:lib%2Flibrary%2F9.pngR2i2410R3R4R5R17R6tgoR0y27:lib%2Flibrary%2Flibrary.binR2i3079R3y4:TEXTR5R18R6tgh","rootPath":null,"version":2,"libraryArgs":["lib/library/library.bin"],"libraryType":"openfl._internal.swf.SWFLiteLibrary"}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("library", library);
		data = '{"name":null,"assets":"aoy4:pathy20:assets%2Flibrary.swfy4:sizei10171y4:typey6:BINARYy2:idR1y7:preloadtgoR2i20885546R3y5:MUSICR5y24:assets%2FNyanCatJazz.mp3y9:pathGroupaR8y24:assets%2FNyanCatJazz.ogghR6tgoR2i46700584R3R7R5R10R9aR8R10hgoR2i2555302R3R7R5y20:assets%2Fpoulenc.mp3R9aR11y20:assets%2Fpoulenc.ogghR6tgoR2i6810867R3R7R5R12R9aR11R12hgoR2i5014R3R7R5y24:assets%2Fsnd_compass.mp3R9aR13y24:assets%2Fsnd_compass.ogghR6tgoR2i6585R3y5:SOUNDR5R14R9aR13R14hgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		
		
		library = Assets.getLibrary ("library");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("library");
		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		
		
		#end
		
	}
	
	
}


#if kha

null

#else

#if !display
#if flash

@:keep @:bind #if display private #end class __ASSET__assets_library_swf extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_nyancatjazz_mp3 extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_nyancatjazz_ogg extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_poulenc_mp3 extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_poulenc_ogg extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_snd_compass_mp3 extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_snd_compass_ogg extends null { }
@:keep @:bind #if display private #end class __ASSET__lib_library_1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__lib_library_11_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__lib_library_13_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__lib_library_15_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__lib_library_17_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__lib_library_19_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__lib_library_21_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__lib_library_23_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__lib_library_3_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__lib_library_5_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__lib_library_7_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__lib_library_9_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__lib_library_library_bin extends null { }
@:keep @:bind #if display private #end class __ASSET__lib_library_json extends null { }
@:keep @:bind #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:file("Assets/library.swf") #if display private #end class __ASSET__assets_library_swf extends haxe.io.Bytes {}
@:keep @:file("Assets/NyanCatJazz.mp3") #if display private #end class __ASSET__assets_nyancatjazz_mp3 extends haxe.io.Bytes {}
@:keep @:file("Assets/NyanCatJazz.ogg") #if display private #end class __ASSET__assets_nyancatjazz_ogg extends haxe.io.Bytes {}
@:keep @:file("Assets/poulenc.mp3") #if display private #end class __ASSET__assets_poulenc_mp3 extends haxe.io.Bytes {}
@:keep @:file("Assets/poulenc.ogg") #if display private #end class __ASSET__assets_poulenc_ogg extends haxe.io.Bytes {}
@:keep @:file("Assets/snd_compass.mp3") #if display private #end class __ASSET__assets_snd_compass_mp3 extends haxe.io.Bytes {}
@:keep @:file("Assets/snd_compass.ogg") #if display private #end class __ASSET__assets_snd_compass_ogg extends haxe.io.Bytes {}
@:keep @:image("C:/Users/Robert/Dev/nyancat/Export/html5/obj/libraries/library/1.png") #if display private #end class __ASSET__lib_library_1_png extends lime.graphics.Image {}
@:keep @:image("C:/Users/Robert/Dev/nyancat/Export/html5/obj/libraries/library/11.png") #if display private #end class __ASSET__lib_library_11_png extends lime.graphics.Image {}
@:keep @:image("C:/Users/Robert/Dev/nyancat/Export/html5/obj/libraries/library/13.png") #if display private #end class __ASSET__lib_library_13_png extends lime.graphics.Image {}
@:keep @:image("C:/Users/Robert/Dev/nyancat/Export/html5/obj/libraries/library/15.png") #if display private #end class __ASSET__lib_library_15_png extends lime.graphics.Image {}
@:keep @:image("C:/Users/Robert/Dev/nyancat/Export/html5/obj/libraries/library/17.png") #if display private #end class __ASSET__lib_library_17_png extends lime.graphics.Image {}
@:keep @:image("C:/Users/Robert/Dev/nyancat/Export/html5/obj/libraries/library/19.png") #if display private #end class __ASSET__lib_library_19_png extends lime.graphics.Image {}
@:keep @:image("C:/Users/Robert/Dev/nyancat/Export/html5/obj/libraries/library/21.png") #if display private #end class __ASSET__lib_library_21_png extends lime.graphics.Image {}
@:keep @:image("C:/Users/Robert/Dev/nyancat/Export/html5/obj/libraries/library/23.png") #if display private #end class __ASSET__lib_library_23_png extends lime.graphics.Image {}
@:keep @:image("C:/Users/Robert/Dev/nyancat/Export/html5/obj/libraries/library/3.png") #if display private #end class __ASSET__lib_library_3_png extends lime.graphics.Image {}
@:keep @:image("C:/Users/Robert/Dev/nyancat/Export/html5/obj/libraries/library/5.png") #if display private #end class __ASSET__lib_library_5_png extends lime.graphics.Image {}
@:keep @:image("C:/Users/Robert/Dev/nyancat/Export/html5/obj/libraries/library/7.png") #if display private #end class __ASSET__lib_library_7_png extends lime.graphics.Image {}
@:keep @:image("C:/Users/Robert/Dev/nyancat/Export/html5/obj/libraries/library/9.png") #if display private #end class __ASSET__lib_library_9_png extends lime.graphics.Image {}
@:keep @:file("C:/Users/Robert/Dev/nyancat/Export/html5/obj/libraries/library/library.bin") #if display private #end class __ASSET__lib_library_library_bin extends haxe.io.Bytes {}
@:keep @:file("") #if display private #end class __ASSET__lib_library_json extends haxe.io.Bytes {}
@:keep @:file("") #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else



#end

#if (openfl && !flash)

#if html5

#else

#end

#end
#end

#end
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
		
		data = '{"name":"library","assets":"ah","rootPath":null,"version":2,"libraryArgs":["lib/library/library.swf"],"libraryType":"openfl._internal.swf.SWFLibrary"}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("library", library);
		data = '{"name":null,"assets":"aoy4:sizei10171y4:typey6:BINARYy9:classNamey27:__ASSET__assets_library_swfy2:idy20:assets%2Flibrary.swfgoR0i20885546R1y5:MUSICR3y31:__ASSET__assets_nyancatjazz_mp3R5y24:assets%2FNyanCatJazz.mp3goR0i46700584R1R7R3y31:__ASSET__assets_nyancatjazz_oggR5y24:assets%2FNyanCatJazz.ogggoR0i2555302R1R7R3y27:__ASSET__assets_poulenc_mp3R5y20:assets%2Fpoulenc.mp3goR0i6810867R1R7R3y27:__ASSET__assets_poulenc_oggR5y20:assets%2Fpoulenc.ogggoR0i5014R1R7R3y31:__ASSET__assets_snd_compass_mp3R5y24:assets%2Fsnd_compass.mp3goR0i6585R1y5:SOUNDR3y31:__ASSET__assets_snd_compass_oggR5y24:assets%2Fsnd_compass.ogggh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
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

@:keep @:bind #if display private #end class __ASSET__assets_library_swf extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__assets_nyancatjazz_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_nyancatjazz_ogg extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_poulenc_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_poulenc_ogg extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__assets_snd_compass_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_snd_compass_ogg extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__lib_library_json extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__manifest_default_json extends flash.utils.ByteArray { }


#elseif (desktop || cpp)

@:keep @:file("Assets/library.swf") #if display private #end class __ASSET__assets_library_swf extends haxe.io.Bytes {}
@:keep @:file("Assets/NyanCatJazz.mp3") #if display private #end class __ASSET__assets_nyancatjazz_mp3 extends haxe.io.Bytes {}
@:keep @:file("Assets/NyanCatJazz.ogg") #if display private #end class __ASSET__assets_nyancatjazz_ogg extends haxe.io.Bytes {}
@:keep @:file("Assets/poulenc.mp3") #if display private #end class __ASSET__assets_poulenc_mp3 extends haxe.io.Bytes {}
@:keep @:file("Assets/poulenc.ogg") #if display private #end class __ASSET__assets_poulenc_ogg extends haxe.io.Bytes {}
@:keep @:file("Assets/snd_compass.mp3") #if display private #end class __ASSET__assets_snd_compass_mp3 extends haxe.io.Bytes {}
@:keep @:file("Assets/snd_compass.ogg") #if display private #end class __ASSET__assets_snd_compass_ogg extends haxe.io.Bytes {}
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
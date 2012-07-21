package
{
	import flash.display.Stage;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class StageAccessor
	{
	    public static var stage:Stage;
	
		private static var container:DisplayObjectContainer;
	
		public static function addChild(child:DisplayObject):void
		{
			container || createContainer();
			container.addChild(child);
		}
		
		public static function removeChild(child:DisplayObject):void
		{
			if(container && container.contains(child))
				container.removeChild(child);
		}
		
		public static function removeAllChildren():void
		{
			refresh();
		}
		
		public static function refresh():void
		{
			if(container && stage.contains(container))
				stage.removeChild(container);
		}
		
		private static function createContainer():void
		{
			container = new Sprite();
			stage.addChild(container);
		}
	}
}
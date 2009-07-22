package net.expantra.smartypants.extra
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	import mx.logging.ILogger;
	
	import net.expantra.smartypants.impl.sp_internal;
	import net.expantra.smartypants.utils.SPLoggingUtil;
	
	[Mixin]
	public class NoSmartyPantsLogging extends EventDispatcher implements ILogger
	{
		private var name:String;
		
		function NoSmartyPantsLogging(name:String):void
		{
			this.name = name;
		}
		
		public static function init(root:DisplayObject):void
		{
			SPLoggingUtil.sp_internal::getDefaultLoggerWorkFunction = replacementGetDefaultLoggerWork;
		}
		
		private static function replacementGetDefaultLoggerWork(name:String):ILogger
		{
			return new NoSmartyPantsLogging(name);
		}
		
		public function get category():String
		{
			return name;
		}
		
		public function log(level:int, message:String, ... rest):void
		{
		}
		
		public function debug(message:String, ... rest):void
		{
		}
		
		public function error(message:String, ... rest):void
		{
		}
		
		public function fatal(message:String, ... rest):void
		{
		}
		
		public function info(message:String, ... rest):void
		{
		}
		
		public function warn(message:String, ... rest):void
		{
		}
	}
}
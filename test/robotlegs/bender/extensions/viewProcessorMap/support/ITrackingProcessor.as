package robotlegs.bender.extensions.viewProcessorMap.support
{
	import org.swiftsuspenders.Injector;
	
	public interface ITrackingProcessor
	{
		function process(view:Object, type:Class, injector:Injector):void;
		
		function unprocess(view:Object, type:Class, injector:Injector):void;
	}

}


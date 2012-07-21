package robotlegs.bender.extensions.viewProcessorMap.impl
{
	import org.swiftsuspenders.Injector;
	import flash.utils.Dictionary;
	import flash.events.IEventDispatcher;

	public class ViewInjectionProcessor
	{		
		private const _injectedObjects:Dictionary = new Dictionary(true);
			
		public function process(view:Object, type:Class, injector:Injector):void
		{
			_injectedObjects[view] || injectAndRemember(view, injector);
		}
		
		public function unprocess(view:Object, type:Class, injector:Injector):void
		{
			// assumption is that teardown is not wanted.
			// if you *do* want teardown, copy this class
		}
		
		private function injectAndRemember(view:Object, injector:Injector):void
		{
			injector.injectInto(view);
			_injectedObjects[view] = view;
		}
	}
}
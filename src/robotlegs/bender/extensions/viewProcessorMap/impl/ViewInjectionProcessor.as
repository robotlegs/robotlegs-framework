package robotlegs.bender.extensions.viewProcessorMap.impl
{
	import org.swiftsuspenders.Injector;
	import flash.utils.Dictionary;
	import flash.events.IEventDispatcher;

	public class ViewInjectionProcessor
	{
		private var _injector:Injector;
		
		private const _injectedObjects:Dictionary = new Dictionary(true);
		
		public function ViewInjectionProcessor(injector:Injector)
		{
			_injector = injector;
		}
	
		public function process(view:Object, type:Class):void
		{
			_injectedObjects[view] || injectAndRemember(view);
		}
		
		public function unprocess(view:Object, type:Class):void
		{
			// assumption is that teardown is not wanted.
			// if you *do* want teardown, copy this class
		}
		
		private function injectAndRemember(view:Object):void
		{
			_injector.injectInto(view);
			_injectedObjects[view] = view;
		}
	}
}
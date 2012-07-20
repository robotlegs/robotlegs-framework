package robotlegs.bender.extensions.viewProcessorMap.impl
{
	public interface IViewProcessorFactory
	{
	 	function runProcessors(view:Object, type:Class, processorMappings:Array):void;
		
		function runUnprocessors(view:Object, type:Class, processorMappings:Array):void;
		
		function runAllUnprocessors():void;
	}
}

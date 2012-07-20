package robotlegs.bender.extensions.viewProcessorMap.impl
{
	import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMapping;
	
	public interface IViewProcessorViewHandler
	{
		function addMapping(mapping:IViewProcessorMapping):void;

		function removeMapping(mapping:IViewProcessorMapping):void;

		function processItem(item:Object, type:Class):void;
	
		function unprocessItem(item:Object, type:Class):void;
	}
}
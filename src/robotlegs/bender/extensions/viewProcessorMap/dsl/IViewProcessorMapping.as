package robotlegs.bender.extensions.viewProcessorMap.dsl
{
	import robotlegs.bender.extensions.matching.ITypeFilter;
	
	public interface IViewProcessorMapping
	{
		function get matcher():ITypeFilter;

		function get processor():Object;

		function set processor(value:Object):void;

		function get processorClass():Class;

		function get guards():Array;

		function get hooks():Array;
	}
}
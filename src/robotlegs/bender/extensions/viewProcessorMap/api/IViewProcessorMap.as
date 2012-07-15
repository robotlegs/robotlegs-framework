package robotlegs.bender.extensions.viewProcessorMap.api
{
	import robotlegs.bender.extensions.matching.ITypeMatcher;
	import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMapper;
	import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorUnmapper;

	public interface IViewProcessorMap
	{
		function mapMatcher(matcher:ITypeMatcher):IViewProcessorMapper;

		function map(type:Class):IViewProcessorMapper;

		function unmapMatcher(matcher:ITypeMatcher):IViewProcessorUnmapper;

		function unmap(type:Class):IViewProcessorUnmapper;
		
		function process(item:Object):void;
		
		function unprocess(item:Object):void;	
	}
}
package robotlegs.bender.extensions.viewProcessorMap.dsl
{
	public interface IViewProcessorMappingConfig
	{
		function withGuards(... guards):IViewProcessorMappingConfig;

		function withHooks(... hooks):IViewProcessorMappingConfig;	
	}
}
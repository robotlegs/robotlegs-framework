package robotlegs.bender.extensions.viewProcessorMap.dsl
{
	public interface IViewProcessorMapper
	{
		function toProcess(processClassOrInstance:*):IViewProcessorMappingConfig;
		
		function toInjection():IViewProcessorMappingConfig;

		function toNoProcess():IViewProcessorMappingConfig;
	}
}

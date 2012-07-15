package robotlegs.bender.extensions.viewProcessorMap.dsl
{

	public interface IViewProcessorUnmapper
	{
		function fromProcess(processorClassOrInstance:*):void;
		
		function fromProcesses():void;
		
		function fromNoProcess():void;
		
		function fromInjection():void;
	}

}


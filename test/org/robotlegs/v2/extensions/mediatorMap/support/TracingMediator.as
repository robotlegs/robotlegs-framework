package org.robotlegs.v2.extensions.mediatorMap.support
{
	import org.robotlegs.v2.extensions.mediatorMap.impl.Mediator;
	import org.robotlegs.v2.extensions.mediatorMap.impl.support.MediatorWatcher;

	public class TracingMediator extends Mediator
	{
	
		[Inject]
		public var mediatorWatcher:MediatorWatcher;
	
		override public function initialize():void
		{
			mediatorWatcher.trackMediator(this);
		}
	
	}

}
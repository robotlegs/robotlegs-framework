package org.robotlegs.v2.extensions.mediatorMapA.support
{
	import org.robotlegs.v2.extensions.mediatorMapA.impl.Mediator;
	import org.robotlegs.v2.extensions.mediatorMapA.impl.support.MediatorWatcher;

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
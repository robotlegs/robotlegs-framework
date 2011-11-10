package org.robotlegs.v2.extensions.mediatorMapA.support
{
	import org.robotlegs.mvcs.Mediator;
	import org.robotlegs.v2.extensions.mediatorMapA.impl.support.MediatorWatcher;

	public class TracingV1Mediator extends Mediator
	{
	
		[Inject]
		public var mediatorWatcher:MediatorWatcher;
	
		override public function onRegister():void
		{
			mediatorWatcher.trackMediator(this);
		}
	
	}

}
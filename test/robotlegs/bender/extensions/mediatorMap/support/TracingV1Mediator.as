package robotlegs.bender.extensions.mediatorMap.support
{
	import org.robotlegs.mvcs.Mediator;
	import robotlegs.bender.extensions.mediatorMap.impl.support.MediatorWatcher;

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
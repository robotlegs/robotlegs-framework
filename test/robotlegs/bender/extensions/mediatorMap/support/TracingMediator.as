package robotlegs.bender.extensions.mediatorMap.support
{
	import robotlegs.bender.extensions.mediatorMap.impl.Mediator;
	import robotlegs.bender.extensions.mediatorMap.impl.support.MediatorWatcher;

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
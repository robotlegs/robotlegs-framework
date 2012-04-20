package robotlegs.bender.core.lifecycle.api
{
	public class LifecycleMessage
	{
		private var _transition:Function;
		private var _timing:Object;
		private var _description:String;
		private var _target:Object;

		public function LifecycleMessage(target:Object, transition:Function, timing:Object, description:String)
		{
			_target = target;
			_transition = transition;
			_timing = timing;
			_description = description;
		}
		
		public function get target():Object
		{
			return _target;
		}

		public function get transition():Function
		{
			return _transition;
		}

		public function get timing():Object
		{
			return _timing;
		}

		public function get description():String
		{
			return _description;
		}
	}
}
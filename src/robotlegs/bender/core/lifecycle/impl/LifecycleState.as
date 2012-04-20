package robotlegs.bender.core.lifecycle.impl
{
	public class LifecycleState
	{
		private var _description:String;

		public function LifecycleState(description:String)
		{
			_description = description;
		}

		public function toString():String
		{
			return '[LifecycleState '+ _description + ']';
		}
	}

}


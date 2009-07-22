package org.springextensions.actionscript.ioc.factory.support
{
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	
	public class RobotLegsObjectFactory extends DefaultListableObjectFactory
	{
		public function RobotLegsObjectFactory()
		{
			super();
		}
		
		public function cacheSingletonValue(objectName:String, value:Object):void
		{
			singletonCache[objectName] = value;
		}
	
	}
}
//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.context.impl
{
	import flash.utils.Dictionary;
	import org.swiftsuspenders.DescribeTypeReflector;
	import org.swiftsuspenders.Reflector;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.logging.api.ILogger;

	public class ExtensionInstaller
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _classes:Dictionary = new Dictionary(true);

		private const _reflector:Reflector = new DescribeTypeReflector();

		private var _context:IContext;

		private var _logger:ILogger;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ExtensionInstaller(context:IContext)
		{
			_context = context;
			_logger = _context.getLogger(this);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function install(extension:Object):void
		{
			if (extension is Class)
			{
				_classes[extensionClass] || install(new extension());
			}
			else
			{
				const extensionClass:Class = _reflector.getClass(extension);
				if (_classes[extensionClass])
					return;
				_logger.debug("Installing extension {0}", [extension]);
				_classes[extensionClass] = true;
				extension.extend(_context);
			}
		}
	}
}

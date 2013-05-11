//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import flash.utils.Dictionary;
	import org.swiftsuspenders.reflection.DescribeTypeReflector;
	import org.swiftsuspenders.reflection.Reflector;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.ILogger;

	/**
	 * Installs custom extensions into a given context
	 *
	 * @private
	 */
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

		/**
		 * @private
		 */
		public function ExtensionInstaller(context:IContext)
		{
			_context = context;
			_logger = _context.getLogger(this);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * Installs the supplied extension
		 * @param extension An object or class implementing IExtension
		 */
		public function install(extension:Object):void
		{
			if (extension is Class)
			{
				_classes[extension] || install(new (extension as Class));
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

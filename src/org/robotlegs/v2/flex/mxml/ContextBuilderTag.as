//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.flex.mxml
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.setTimeout;
	import mx.core.IMXMLObject;
	import org.robotlegs.v2.core.api.IContextBuilderBundle;
	import org.robotlegs.v2.core.impl.ContextBuilder;

	[DefaultProperty("configs")]
	public class ContextBuilderTag extends ContextBuilder implements IMXMLObject
	{

		protected var _configs:Vector.<IContextBuilderBundle> = new Vector.<IContextBuilderBundle>;

		public function get configs():Vector.<IContextBuilderBundle>
		{
			return _configs;
		}

		public function set configs(value:Vector.<IContextBuilderBundle>):void
		{
			_configs = value;
		}

		protected var _contextView:DisplayObjectContainer;

		public function set contextView(value:DisplayObjectContainer):void
		{
			_contextView = value;
		}

		protected var _documentView:DisplayObjectContainer;

		public function initialized(document:Object, id:String):void
		{
			_documentView = document as DisplayObjectContainer;
			// if the contextView is bound it will only be set a frame later
			setTimeout(configureBuilder, 1);
		}

		protected function configureBuilder():void
		{
			if (!context.contextView)
			{
				withContextView(_contextView || _documentView);
			}

			configs.forEach(function(config:IContextBuilderBundle, ... rest):void
			{
				withBundle(config['constructor'] as Class);
			}, this);

			configs = null;

			build();
		}
	}
}

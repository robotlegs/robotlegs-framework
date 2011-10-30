//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.view.impl
{
	import flash.system.ApplicationDomain;
	import org.robotlegs.v2.view.api.IViewClassInfo;

	public class ViewClassInfo implements IViewClassInfo
	{

		public function get applicationDomain():ApplicationDomain
		{
			return _domain;
		}

		private var _fqcn:String;

		public function get fqcn():String
		{
			return _fqcn;
		}

		private var _type:Class;

		public function get type():Class
		{
			return _type;
		}

		public function get typeNames():Vector.<String>
		{
			// todo: lazy, cached list of type names
			return null;
		}

		private var _domain:ApplicationDomain;

		public function ViewClassInfo(type:Class, fqcn:String, domain:ApplicationDomain)
		{
			_type = type;
			_fqcn = fqcn;
			_domain = domain;
		}

		public function isType(type:Class):Boolean
		{
			// todo: lazy, cached evaluation
			return false;
		}
	}
}

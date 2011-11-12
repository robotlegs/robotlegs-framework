//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.impl
{
	import org.robotlegs.v2.core.api.ITypeFilter;
	import flash.utils.getQualifiedClassName;

	public class PackageFilter implements ITypeFilter
	{
		protected const emptyVector:Vector.<Class> = new Vector.<Class>();
		
		protected var _requirePackage:String;

		protected var _anyOfPackages:Vector.<String>;

		protected var _noneOfPackages:Vector.<String>;
		
		public function PackageFilter(requiredPackage:String, anyOfPackages:Vector.<String>, noneOfPackages:Vector.<String>)
		{
			_requirePackage = requiredPackage;
			_anyOfPackages = anyOfPackages;
			_noneOfPackages = noneOfPackages;
		}
		
		public function get allOfTypes():Vector.<Class>
		{
			return emptyVector;
		}

		public function get anyOfTypes():Vector.<Class>
		{
			return emptyVector;
		}

		public function get noneOfTypes():Vector.<Class>
		{
			return emptyVector;
		}

		public function get descriptor():String
		{
			return '';
		}

		public function matches(item:*):Boolean
		{
			const fqcn:String = getQualifiedClassName(item);
			var packageName:String;
			
			if(_requirePackage && (!matchPackageInFQCN(_requirePackage, fqcn)))
				return false;
			
			for each (packageName in _noneOfPackages)
			{
				if(matchPackageInFQCN(packageName, fqcn))
					return false;
			}
			
			for each (packageName in _anyOfPackages)
			{
				if(matchPackageInFQCN(packageName, fqcn))
					return true;
			}
			if(_anyOfPackages.length > 0)
				return false;
			
			if(_requirePackage)
				return true;

			if(_noneOfPackages.length > 0)
				return true;
			
			return false;
		}
		
		private function matchPackageInFQCN(packageName:String, fqcn:String):Boolean
		{
			trace("PackageFilter::matchPackageInFQCN()", packageName, fqcn, (fqcn.indexOf(packageName) == 0));
			return (fqcn.indexOf(packageName) == 0)
		}

	}
}
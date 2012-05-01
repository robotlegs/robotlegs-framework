//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.matching
{
	import flash.errors.IllegalOperationError;

	// TODO: review (location)
	public class PackageMatcher implements ITypeMatcher
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var _requirePackage:String;

		protected const _anyOfPackages:Vector.<String> = new Vector.<String>();

		protected const _noneOfPackages:Vector.<String> = new Vector.<String>();

		protected var _typeFilter:ITypeFilter;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function createTypeFilter():ITypeFilter
		{
			return _typeFilter ||= buildTypeFilter();
		}

		public function require(fullPackage:String):PackageMatcher
		{
			if (_typeFilter)
				throwSealedMatcherError();

			if (_requirePackage)
				throw new IllegalOperationError('You can only set one required package on this PackageMatcher (two non-nested packages cannot both be required, and nested packages are redundant.)');

			_requirePackage = fullPackage;
			return this;
		}

		public function anyOf(... packages):PackageMatcher
		{
			pushAddedPackagesTo(packages, _anyOfPackages);
			return this;
		}

		public function noneOf(... packages):PackageMatcher
		{
			pushAddedPackagesTo(packages, _noneOfPackages);
			return this;
		}

		public function lock():void
		{
			createTypeFilter();
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function buildTypeFilter():ITypeFilter
		{
			if (((!_requirePackage) || _requirePackage.length == 0) &&
				(_anyOfPackages.length == 0) &&
				(_noneOfPackages.length == 0))
			{
				throw new TypeMatcherError(TypeMatcherError.EMPTY_MATCHER);
			}
			return new PackageFilter(_requirePackage, _anyOfPackages, _noneOfPackages);
		}

		protected function pushAddedPackagesTo(packages:Array, targetSet:Vector.<String>):void
		{
			_typeFilter && throwSealedMatcherError();

			pushValuesToStringVector(packages, targetSet);
		}

		protected function throwSealedMatcherError():void
		{
			throw new IllegalOperationError('This TypeMatcher has been sealed and can no longer be configured');
		}

		protected function pushValuesToStringVector(values:Array, vector:Vector.<String>):void
		{
			if (values.length == 1
				&& (values[0] is Array || values[0] is Vector.<String>))
			{
				for each (var packageName:String in values[0])
				{
					vector.push(packageName);
				}
			}
			else
			{
				for each (packageName in values)
				{
					vector.push(packageName);
				}
			}
		}
	}
}

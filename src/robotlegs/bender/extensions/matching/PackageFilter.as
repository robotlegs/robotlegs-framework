//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.matching
{
	import flash.utils.getQualifiedClassName;

	/**
	 * A filter that describes a package matcher
	 */
	public class PackageFilter implements ITypeFilter
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		protected var _descriptor:String;

		/**
		 * @inheritDoc
		 */
		public function get descriptor():String
		{
			return _descriptor ||= createDescriptor();
		}

		/**
		 * @inheritDoc
		 */
		public function get allOfTypes():Vector.<Class>
		{
			return emptyVector;
		}

		/**
		 * @inheritDoc
		 */
		public function get anyOfTypes():Vector.<Class>
		{
			return emptyVector;
		}

		/**
		 * @inheritDoc
		 */
		public function get noneOfTypes():Vector.<Class>
		{
			return emptyVector;
		}

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected const emptyVector:Vector.<Class> = new Vector.<Class>();

		protected var _requirePackage:String;

		protected var _anyOfPackages:Vector.<String>;

		protected var _noneOfPackages:Vector.<String>;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a new Package Filter
		 * @param requiredPackage
		 * @param anyOfPackages
		 * @param noneOfPackages
		 */
		public function PackageFilter(
			requiredPackage:String,
			anyOfPackages:Vector.<String>,
			noneOfPackages:Vector.<String>)
		{
			_requirePackage = requiredPackage;
			_anyOfPackages = anyOfPackages;
			_noneOfPackages = noneOfPackages;
			_anyOfPackages.sort(stringSort);
			_noneOfPackages.sort(stringSort);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function matches(item:*):Boolean
		{
			const fqcn:String = getQualifiedClassName(item);
			var packageName:String;

			if (_requirePackage && (!matchPackageInFQCN(_requirePackage, fqcn)))
				return false;

			for each (packageName in _noneOfPackages)
			{
				if (matchPackageInFQCN(packageName, fqcn))
					return false;
			}

			for each (packageName in _anyOfPackages)
			{
				if (matchPackageInFQCN(packageName, fqcn))
					return true;
			}
			if (_anyOfPackages.length > 0)
				return false;

			if (_requirePackage)
				return true;

			if (_noneOfPackages.length > 0)
				return true;

			return false;
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function stringSort(item1:String, item2:String):int
		{
			if (item1 > item2)
			{
				return 1;
			}
			return -1;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createDescriptor():String
		{
			return "require: " + _requirePackage
				+ ", any of: " + _anyOfPackages.toString()
				+ ", none of: " + _noneOfPackages.toString();
		}

		private function matchPackageInFQCN(packageName:String, fqcn:String):Boolean
		{
			return (fqcn.indexOf(packageName) == 0)
		}
	}
}

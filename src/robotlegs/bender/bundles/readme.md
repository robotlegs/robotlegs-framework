# Robotlegs Bundles

## Extensions vs Bundles

An extension integrates a single utility or library into a Robotlegs context.

A bundle bundles up a selection of extensions and configurations into a single package.

## Creating a Bundle

A bundle implements the IContextConfig interface. When included into a context, that context is immediately passed through to the configureContext() method.

    package robotlegs.bundles.superDuper
    {
      public class SuperDuperBundle implements IContextConfig
      {
        public function configureContext(context:IContext):void
        {
          context.require(
	        SuperDuperExtensionA,
	        SuperDuperExtensionB,
	        SuperDuperExtensionC
	      );
        }
      }
    }

NOTE: The context instance provided to configureContext() may not be fully initialized.


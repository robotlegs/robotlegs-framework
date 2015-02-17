# Manual Stage Observer Extension

The manual stage observer extension is not installed in the MVCSBundle, the automatic StageObserverExtension is added instead.

The manual stage observer allows you to register your views manually with bubbling events.

In order to register a view, you still need to have a container registered in the ContainerRegistry, which is usually installed in the ViewManager/ContextView extension.

## How to Install

You can install this extension like so:

```as3
context.install(ManualStageObserver);
```

## How to use

You can manually send views to be processed with event bubbling.
All you have to do is dispatch a ConfigureViewEvent from that view that needs to be processed.

Here is an example of sprite that will get processed after it has been added to stage:


```as3
package robotlegs.bender.extensions.viewManager.impl
{
	import flash.display.Sprite;
    import robotlegs.bender.extensions.viewManager.impl;

	public class ManualRegisteredView : Sprite
	{
		public function ManualRegisteredView()
        {
			addEventListner(Event.ADDED_TO_STAGE, init, false, 0, true);
        }

		private function init(e:Event):void
        {
			dispatchEvent(new ConfigureViewEvent(ConfigureViewEvent.CONFIGURE_VIEW));
		}
	}
}
```

Again, this will only get registered if the view is a child of a container like the ContextView.
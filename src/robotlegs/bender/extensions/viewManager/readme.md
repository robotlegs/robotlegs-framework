# View Manager Extension

## Overview

The View Manager extension allows you to add ContainersBindings. This stores a container (typically a root parent of a set of views), add multiple IViewHandlers (classes that can perform an action on a view) and have a function to invoke all IViewHandlers.

The View Manager classes are used internally to handle views and process them. If you want to add view handlers, consider using the ViewProcessorMap for more functionality which is installed by the MVCSBundle.

If you want to know how the view's are added to ContainerBindings, see the [ManualStageObserverExtension](ManualStageObserverExtension.md), [StageObserverExtension](StageObserverExtension.md) and [StageCrawlerExtension](StageCrawlerExtension.md).

## How to Install

This extension is already installed in the MVCS bundle, but if you're not using that:

```as3
context.install(ViewManagerExtension);
```

## What does it install

The View Manager extension, installs creates and maps a static ContainerRegistry (if not created already). Which holds all ContainerBindings of multiple contexts and a ViewManager which adds ContainerBindings for one Context.

They are both injectable

```as3
[Inject]
public var containerRegistry:ContainerRegistry;

[Inject]
public var viewManager:ViewManager;
```

## How it works

### Container Registry

The ContainerRegistry holds a reference of ContainerBindings (the root DisplayObjectContainer of multiple views) and their relation between each other (child/parent).

You can add a container which returns a container binding.

```as3
var containerBinding:ContainerBinding = containerRegistry.addContainer(mySprite);
trace("I've just added: " + containerBinding.container);
```

It's then possible to see which ContainerBinding is the closest parent of any view.

```as3
var binding:ContainerBinding = containerRegistry.findParentBinding(view);
if (binding)
{
	trace("Closest parent container of view " + view + " is " + binding.container);
}
else
{
	trace("No parent container found for view " + view);
}
```

A ContainerBinding has the ability to add multiple 'IViewHandlers' with the ```addHandler``` method and invoke them with passing a view when you call ```handleView```.

```as3
binding.handleView(view, Sprite);
```

### View Manager

The View Manager allows you to add the same IViewHandlers to multiple containers. It does this by using the container registry for you, but doesn't expose to you their container bindings.

You can add containers to a view manager like so:

```as3
viewManager.addContainer(mySprite1);
viewManager.addContainer(mySprite2);
```

Then you can add IViewHandlers to all containers like so:

```as3
viewManager.addViewHandler(myViewHandler);
```

Adding a container later, will also add any previous viewHandlers to it.

```as3
viewManager.addContainer(mySprite3);
// MySprite3 ContainerBinding has just had 'myViewHander' added to it.
```

In order to process the view handlers, you still need to get the binding from the container registry.

```as3
var binding:ContainerBinding = containerRegistry.findParentBinding(childOfMySprite3);
binding.handleView(view, Sprite);
```

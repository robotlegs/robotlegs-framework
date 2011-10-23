//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.viewmanager
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import org.robotlegs.v2.viewmanager.listeningstrategies.ListeningStrategies;
	import org.robotlegs.v2.viewmanager.tasks.ITaskHandler;
	import org.robotlegs.v2.viewmanager.tasks.TaskHandlerResponse;

	// that's "DoctorSpy" to the likes of you (or DisplayObjectContainerSpy)
	public class DocSpy implements ISpy
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		protected var _listeningStrategy:IListeningStrategy = ListeningStrategies.AUTO;

		public function get listeningStrategy():IListeningStrategy
		{
			return _listeningStrategy;
		}

		public function set listeningStrategy(strategy:IListeningStrategy):void
		{
			_listeningStrategy = strategy;
		}

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var _addedListenerMap:IListenerMap;

		protected const _addedType:String = Event.ADDED_TO_STAGE;

		protected const _removedHandlersByHandledView:Dictionary = new Dictionary(false);

		protected var _removedListenerMap:IListenerMap;

		protected const _removedType:String = Event.REMOVED_FROM_STAGE;

		protected const _taskHandlersByDoc:Dictionary = new Dictionary(false);

		protected var _treeCreeper:IContainerTreeCreeper;


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		// taskType eg "ViewMediationTask" to allow for blocking of further handling of this task-flavour by outer containers
		// and should we return the binding here? In which case we could add another function to the binding that allowed you to
		// removeInterest() in one go? Maybe it should be an InterestBinding, containing the ContainerBinding?
		public function addInterest(target:DisplayObjectContainer, taskHandler:ITaskHandler):void
		{
			// TODO - are we going to permit more than one handler per target per eventType per taskType?
			// but then how does the 'I got this!' work if different maps are overlapping... hrm. 
			// warn them if they add more than one? Or error?

			if (!_treeCreeper)
			{
				initialise();
			}

			_treeCreeper.includeContainer(target);

			const taskHandlers:Dictionary = _taskHandlersByDoc[target] ||= new Dictionary();
			taskHandlers[taskHandler.taskType] = taskHandler;

			updateRootsAndListenerTargets(_treeCreeper);
		}

		// could return the removed binding if it was symmetrical with above  
		// TODO - needs to remove the 'removed from stage' handler too
		public function removeInterest(target:DisplayObjectContainer, taskHandler:ITaskHandler):void
		{
			if ((!_treeCreeper) || (!_taskHandlersByDoc[target]) ||
				(!_taskHandlersByDoc[target][taskHandler.taskType]))
			{
				return;
			}

			_treeCreeper.excludeContainer(target);

			delete _taskHandlersByDoc[target][taskHandler.taskType];

			updateRootsAndListenerTargets(_treeCreeper);
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function initialise():IContainerTreeCreeper
		{
			_treeCreeper = new ContainerTreeCreeper();
			_addedListenerMap = new ListenerMap(_addedType, routeAddedEventToInterestedParties);
			_removedListenerMap = new ListenerMap(_removedType, routeRemovedEventToInterestedParties);
			return _treeCreeper;
		}

		protected function routeAddedEventToInterestedParties(e:Event):void
		{
			var targetContainerBinding:IContainerBinding = _treeCreeper.findParentBindingFor(e.target as DisplayObject);

			const blockedTasks:Dictionary = new Dictionary();
			var handlersByTask:Dictionary;
			var response:uint;
			var taskType:*;
			const removedHandlersForThisView:Vector.<Function> = new Vector.<Function>();

			while (targetContainerBinding)
			{
				handlersByTask = _taskHandlersByDoc[targetContainerBinding.container];

				for (taskType in handlersByTask)
				{
					if (!blockedTasks[taskType])
					{
						// blocked on a task type basis
						// ie a 'ViewMediationTask' can block further ViewMediationTasks
						response = handlersByTask[taskType].addedHandler(e);
						if (response == TaskHandlerResponse.HANDLED_AND_BLOCKED)
						{
							blockedTasks[taskType] = targetContainerBinding.container;
						}
						if ((response > 0) && (handlersByTask[taskType].removedHandler))
						{
							removedHandlersForThisView.push(handlersByTask[taskType].removedHandler);
						}
					}
				}

				targetContainerBinding = targetContainerBinding.parent;
			}

			if (removedHandlersForThisView.length > 0)
			{
				_removedHandlersByHandledView[e.target] = removedHandlersForThisView;
			}
		}

		protected function routeRemovedEventToInterestedParties(e:Event):void
		{
			if (!_removedHandlersByHandledView[e.target])
			{
				return;
			}

			const removedHandlersForThisView:Vector.<Function> = _removedHandlersByHandledView[e.target];

			const iLength:uint = removedHandlersForThisView.length;
			for (var i:uint = 0; i < iLength; i++)
			{
				removedHandlersForThisView[i](e);
			}

			delete _removedHandlersByHandledView[e.target];
		}

		protected function updateRootsAndListenerTargets(treeCreeper:IContainerTreeCreeper):void
		{
			const roots:Vector.<IContainerBinding> = _treeCreeper.rootContainerBindings;
			const docRoots:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();

			const iLength:uint = roots.length;
			for (var i:uint = 0; i < iLength; i++)
			{
				docRoots.push(roots[i].container);
			}

			const listenerChangeRequired:Boolean = _listeningStrategy.updateTargets(docRoots);
			if (listenerChangeRequired)
			{
				_addedListenerMap.updateListenerTargets(Vector.<IEventDispatcher>(_listeningStrategy.targets));
				_removedListenerMap.updateListenerTargets(Vector.<IEventDispatcher>(_listeningStrategy.targets));
			}
		}
	}
}

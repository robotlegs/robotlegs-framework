package org.robotlegs.v2.viewmanager 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import org.robotlegs.v2.viewmanager.ContainerTreeCreeper;
	import org.robotlegs.v2.viewmanager.IContainerBinding;
	import org.robotlegs.v2.viewmanager.IListeningStrategyFactory;
	import org.robotlegs.v2.viewmanager.listeningstrategies.ListeningStrategies;
	import org.robotlegs.v2.viewmanager.tasks.TaskHandler;
	
	// that's "DoctorSpy" to the likes of you (or DisplayObjectContainerSpy)
	public class DocSpy implements ISpy 
	{
		protected const _listeningStrategyFactory:IListeningStrategyFactory = new ListeningStrategyFactory();
		protected var _listeningStrategy:IListeningStrategy = ListeningStrategies.AUTO;
		                                                                                 
		// Four dictionaries... count em!
		
		protected var _treeCreepersByEventType:Dictionary = new Dictionary(false);
		protected var _taskHandlersByTreeCreeperAndDoc:Dictionary = new Dictionary(false);
		protected var _listenerStrategiesByTreeCreeper:Dictionary = new Dictionary(false);
		protected var _listenerMapsByTreeCreeper:Dictionary = new Dictionary(false);
		
		public function get listeningStrategy():IListeningStrategy
		{
			return _listeningStrategy;
		}
		
		public function set listeningStrategy(strategy:IListeningStrategy):void
		{
			_listeningStrategy = strategy;
		}
        
		// taskType eg "ViewMediationTask" to allow for blocking of further handling of this task-flavour by outer containers
		// and should we return the binding here? In which case we could add another function to the binding that allowed you to
		// removeInterest() in one go? Maybe it should be an InterestBinding, containing the ContainerBinding?
		public function addInterestIn(target:DisplayObjectContainer, eventType:String, callback:Function, taskType:Class):void
		{
			// TODO - are we going to permit more than one handler per target per eventType per taskType?
			// but then how does the 'I got this!' work if different maps are overlapping... hrm. 
			// warn them if they add more than one? Or error?
			
			const treeCreeper:ContainerTreeCreeper = _treeCreepersByEventType[eventType] ||= createTreeCreeperForEvent(eventType);
			
			treeCreeper.includeContainer(target);
			
			const taskHandlers:Dictionary = _taskHandlersByTreeCreeperAndDoc[treeCreeper][target] ||= new Dictionary();
			taskHandlers[taskType] = callback;
			
			updateRootsAndListenerTargets(treeCreeper);
		}    
		
		// could return the removed binding if it was symmetrical with above
		public function removeInterestIn(target:DisplayObjectContainer, eventType:String, callback:Function, taskType:Class):void
		{
			const treeCreeper:ContainerTreeCreeper = _treeCreepersByEventType[eventType];
			
			if((!treeCreeper) || (!_taskHandlersByTreeCreeperAndDoc[treeCreeper][target]) ||
			 	(!_taskHandlersByTreeCreeperAndDoc[treeCreeper][target][taskType] ) )
			{
				return;
			}
			
			treeCreeper.excludeContainer(target);
			
			delete _taskHandlersByTreeCreeperAndDoc[treeCreeper][target][taskType];
			
			updateRootsAndListenerTargets(treeCreeper);
		}                                          
		
		
		
		protected function updateRootsAndListenerTargets(treeCreeper:ContainerTreeCreeper):void
		{
			const roots:Vector.<IContainerBinding> = treeCreeper.rootContainerBindings;
			const docRoots:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
			
			const iLength:uint = roots.length;
			for (var i:uint = 0; i < iLength; i++)
			{
				docRoots.push(roots[i].container);
			}
			
			const treeListeningStrategy:IListeningStrategy = _listenerStrategiesByTreeCreeper[treeCreeper];
			const listenerChangeRequired:Boolean = treeListeningStrategy.updateTargets(docRoots);
			if(listenerChangeRequired)
			{
				_listenerMapsByTreeCreeper[treeCreeper].updateListenerTargets(Vector.<IEventDispatcher>(treeListeningStrategy.targets));
			}
		}                                                                          
		
		protected function createListenerFor(treeCreeper:ContainerTreeCreeper):Function
		{
			const evtHandler:Function = function(e:Event):void
			{
				routeEventToInterestedParties(e, treeCreeper);
			}
			
			return evtHandler;
		} 
		
		protected function routeEventToInterestedParties(e:Event, treeCreeper:ContainerTreeCreeper):void
		{
			var targetContainerBinding:IContainerBinding = treeCreeper.findParentBindingFor(e.target as DisplayObject); 
			
		    const blockedTasks:Dictionary = new Dictionary();
			var handlersByTask:Dictionary;
			var allowFurtherResponses:Boolean;
			var taskType:*;    
		
			while(targetContainerBinding)
			{
				handlersByTask = _taskHandlersByTreeCreeperAndDoc[treeCreeper][targetContainerBinding.container];
				
				for (taskType in handlersByTask)
				{
					if(!blockedTasks[taskType])
					{
						// blocked on a task type basis
						// ie a 'ViewMediationTask' can block further ViewMediationTasks
						allowFurtherResponses = handlersByTask[taskType](e);
						if(!allowFurtherResponses)
						{
							blockedTasks[taskType] = targetContainerBinding.container;
						}          
					}
				}

				targetContainerBinding = targetContainerBinding.parent;
			}
		}

		protected function createTreeCreeperForEvent(eventType:String):ContainerTreeCreeper
		{
			const treeCreeper:ContainerTreeCreeper = new ContainerTreeCreeper();
			const strategy:IListeningStrategy = _listeningStrategyFactory.createStrategyLike(_listeningStrategy);
			_listenerStrategiesByTreeCreeper[treeCreeper] = strategy;  
			_taskHandlersByTreeCreeperAndDoc[treeCreeper] = new Dictionary();
			_listenerMapsByTreeCreeper[treeCreeper] = new ListenerMap(eventType, createListenerFor(treeCreeper));
			
			return treeCreeper;
		}
	}
}
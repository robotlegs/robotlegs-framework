## core api
1. injector 
	- singleness											
	- injection point
	- injection rule
	- scope                                                 *
	- softness                                              *
	- factory                                               *
	- name
	- creation hooks                                        *
	- destruction hooks                                     *
	- guards                                                *
	- optional?                                             *
1. context builder
 	- root view                                             *
	- maps                                                  *
	- private / public                                      *
	- sealed                                                *
	- using config                                          *
	- external dependencies                                 *
	- dev / test / release mode                             *
1. mediator map
	- view/s to target                                      *
	- mediators to create
	- guards                                                *
	- hooks                                                 *
	- auto-remove                                            
	- manual
1. view map
    - view/s to target                                      *
	- inject into view?                                     *
	- fast-inject?                                          *
	- guards                                                *
	- hooks                                                 *
1. command map
	- event type
	- command class/es
	- command flow/s                                        *
	- guards                                                *
	- one shot?
	- params?                                               *
	- manual execution
	- async / detain / release

--- BETA MINIMUM ---

1. type matcher
	- class/es                                              *
	- interface/s                                           *
	- excluded class/es                                     *
	- excluded interface/s                                  *
	- subclasses                                            *
	- superclasses                                          *
	- and / or / not / nand                                 *
1. rule set manager        
    - always                                                *
	- when                                                  *
	- until                                                 *
	- restore                                               *
	- whether to validate / predict problems                *
1. context relationship manager (modules)
	- inherit from                                          *
	- share with                                            *
	- pull / push                                           *
	- publish                                               *
	- reference                                             *
	- communication                                         *
1. command flow
	- entry                                                 *
	- entry hooks                                           *
	- command                                               *
	- outcome events                                        *
	- where next...                                         *
	- step fails                                            *
	- overall fail                                          *
	- guards                                                *
	- retry?                                                *
	- timeout?                                              *
1. environment properties / loader
	- target file                                           *
	- format                                                *
	- behaviour on error                                    *
	- validation                                            *
	- parser                                                *
	- location for stored props                             *
	- whether to map/inject after loading                   *
               
## tools
1. inspector gadget
	- all injections
	- object graph
	- event history
	- command history
	- mapping relationships
	- unconventional mappings
	- errors over runtime 
	- counts - listeners, actions, dependencies
	- logging
1. test dsl                
        
## for extension
1. view manager
	- view roots
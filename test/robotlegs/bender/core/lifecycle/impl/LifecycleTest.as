//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.lifecycle.impl
{
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.nullValue;
	import robotlegs.bender.core.async.support.createAsyncHandler;
	import robotlegs.bender.core.async.support.createCallbackHandlerThatErrors;
	import robotlegs.bender.core.async.support.createHandler;
	import robotlegs.bender.core.lifecycle.api.*;
	import robotlegs.bender.core.lifecycle.impl.*;

	public class LifecycleTest
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public function get inExpectedState():Boolean
		{
			return ((!_handlerExpectedState) || (_handlerExpectedState == instance.state));
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var instance:Lifecycle;

		private var _invalidTransitionAttempted:Boolean;

		private var _handlersRun:Array;

		private var _handlerExpectedState:LifecycleState;

		private var _messageReceived:Object;

		private var _errorsReceived:*;

		private var _lifecycleMessageReceived:LifecycleMessage;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			instance = new Lifecycle();
			instance.invalidTransitionHandler = LOG_INVALID_TRANSITIONS;
			_invalidTransitionAttempted = false;
			_handlersRun = [];
			_handlerExpectedState = null;
			_messageReceived = null;
			_errorsReceived = null;
			_lifecycleMessageReceived = null;
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function can_be_instantiated():void
		{
			assertThat(instance, isA(Lifecycle));
		}

		[Test]
		public function initial_state_is_unborn():void
		{
			assertStateIs(Lifecycle.UNBORN);
		}

		[Test]
		public function get_target():void
		{
			const targetObject:Object = {};
			const targettedInstance:Lifecycle = new Lifecycle(targetObject);
			assertThat(targettedInstance.target, equalTo(targetObject));
		}

		//----- FROM Lifecycle.UNBORN

		[Test]
		public function initializing_unborn_turns_state_to_active():void
		{
			instance.initialize();
			assertStateIs(Lifecycle.ACTIVE);
		}

		[Test]
		public function suspending_unborn_leaves_state_unborn():void
		{
			instance.suspend();
			assertStateIs(Lifecycle.UNBORN);
		}

		[Test]
		public function resuming_unborn_leaves_state_unborn():void
		{
			instance.resume();
			assertStateIs(Lifecycle.UNBORN);
		}

		[Test]
		public function destroying_unborn_leaves_state_unborn():void
		{
			instance.destroy();
			assertStateIs(Lifecycle.UNBORN);
		}

		[Test]
		public function initializing_when_unborn_doesnt_run_error():void
		{
			instance.initialize();
			assertTransitionWasValid();
		}

		[Test]
		public function suspending_unborn_runs_error():void
		{
			instance.suspend();
			assertTransitionWasInvalid();
		}

		[Test]
		public function resuming_unborn_runs_error():void
		{
			instance.resume();
			assertTransitionWasInvalid();
		}

		[Test]
		public function destroying_unborn_runs_error():void
		{
			instance.destroy();
			assertTransitionWasInvalid();
		}

		//----- FROM Lifecycle.ACTIVE

		[Test]
		public function initializing_active_leaves_state_active():void
		{
			instance.initialize();
			instance.initialize();
			assertStateIs(Lifecycle.ACTIVE);
		}

		[Test]
		public function suspending_active_turns_state_to_suspended():void
		{
			instance.initialize();
			instance.suspend();
			assertStateIs(Lifecycle.SUSPENDED);
		}

		[Test]
		public function resuming_active_leaves_state_active():void
		{
			instance.initialize();
			instance.resume();
			assertStateIs(Lifecycle.ACTIVE);
		}

		[Test]
		public function destroying_active_turns_state_to_destroyed():void
		{
			instance.initialize();
			instance.destroy();
			assertStateIs(Lifecycle.DESTROYED);
		}

		[Test]
		public function initializing_when_active_runs_error():void
		{
			instance.initialize();
			instance.initialize();
			assertTransitionWasInvalid();
		}

		[Test]
		public function suspending_when_active_doesnt_run_error():void
		{
			instance.initialize();
			instance.suspend();
			assertTransitionWasValid();
		}

		[Test]
		public function resuming_when_active_runs_error():void
		{
			instance.initialize();
			instance.resume();
			assertTransitionWasInvalid();
		}

		[Test]
		public function destroying_when_active_doesnt_run_error():void
		{
			instance.initialize();
			instance.destroy();
			assertTransitionWasValid();
		}

		//----- FROM Lifecycle.SUSPENDED

		[Test]
		public function initializing_suspended_leaves_state_suspended():void
		{
			instance.initialize();
			instance.suspend();
			instance.initialize();
			assertStateIs(Lifecycle.SUSPENDED);
		}

		[Test]
		public function suspending_suspended_leaves_state_suspended():void
		{
			instance.initialize();
			instance.suspend();
			instance.suspend();
			assertStateIs(Lifecycle.SUSPENDED);
		}

		[Test]
		public function resuming_suspended_turns_state_to_active():void
		{
			instance.initialize();
			instance.suspend();
			instance.resume();
			assertStateIs(Lifecycle.ACTIVE);
		}

		[Test]
		public function destroying_suspended_turns_state_to_destroyed():void
		{
			instance.initialize();
			instance.suspend();
			instance.destroy();
			assertStateIs(Lifecycle.DESTROYED);
		}

		[Test]
		public function initializing_when_suspended_runs_error():void
		{
			instance.initialize();
			instance.suspend();
			instance.initialize();
			assertTransitionWasInvalid();
		}

		[Test]
		public function suspending_when_suspended_doesnt_run_error():void
		{
			instance.initialize();
			instance.suspend();
			instance.suspend();
			assertTransitionWasValid();
		}

		[Test]
		public function resuming_when_suspended_doesnt_run_error():void
		{
			instance.initialize();
			instance.suspend();
			instance.resume();
			assertTransitionWasValid();
		}

		[Test]
		public function destroying_when_suspended_doesnt_run_error():void
		{
			instance.initialize();
			instance.suspend();
			instance.destroy();
			assertTransitionWasValid();
		}

		//----- FROM Lifecycle.DESTROYED

		[Test]
		public function initializing_destroyed_leaves_state_destroyed():void
		{
			instance.initialize();
			instance.destroy();
			instance.initialize();
			assertStateIs(Lifecycle.DESTROYED);
		}

		[Test]
		public function suspending_destroyed_leaves_state_destroyed():void
		{
			instance.initialize();
			instance.destroy();
			instance.suspend();
			assertStateIs(Lifecycle.DESTROYED);
		}

		[Test]
		public function resuming_destroyed_leaves_state_destroyed():void
		{
			instance.initialize();
			instance.destroy();
			instance.resume();
			assertStateIs(Lifecycle.DESTROYED);
		}

		[Test]
		public function destroying_destroyed_leaves_state_destroyed():void
		{
			instance.initialize();
			instance.destroy();
			instance.destroy();
			assertStateIs(Lifecycle.DESTROYED);
		}

		[Test]
		public function initializing_destroyed_runs_error():void
		{
			instance.initialize();
			instance.destroy();
			instance.initialize();
			assertTransitionWasInvalid();
		}

		[Test]
		public function suspending_destroyed_runs_error():void
		{
			instance.initialize();
			instance.destroy();
			instance.suspend();
			assertTransitionWasInvalid();
		}

		[Test]
		public function resuming_destroyed_runs_error():void
		{
			instance.initialize();
			instance.destroy();
			instance.resume();
			assertTransitionWasInvalid();
		}

		[Test]
		public function destroying_when_destroyed_doesnt_run_error():void
		{
			instance.initialize();
			instance.destroy();
			assertTransitionWasValid();
		}

		//------ Handler tests

		[Test]
		public function a_handler_added_to_beforeInitializing_is_not_run_prior_to_initialize():void
		{
			instance.beforeInitializing(handleWithoutError);
			assertThat(_handlersRun.length, equalTo(0));
		}

		[Test]
		public function a_handler_added_to_beforeInitializing_is_run_prior_to_initialize():void
		{
			instance.beforeInitializing(handleWithoutError);
			_handlerExpectedState = Lifecycle.BORN;
			instance.initialize();
			assertThat(_handlersRun[0], equalTo(handleWithoutError));
		}

		[Test]
		public function a_handler_added_to_whenInitializing_is_run_after_initialize():void
		{
			instance.whenInitializing(handleWithoutError);
			_handlerExpectedState = Lifecycle.ACTIVE;
			instance.initialize();
			assertThat(_handlersRun[0], equalTo(handleWithoutError));
		}

		[Test]
		public function a_handler_added_to_afterInitializing_is_run_after_initialize():void
		{
			instance.afterInitializing(handleWithoutError);
			_handlerExpectedState = Lifecycle.ACTIVE;
			instance.initialize();
			assertThat(_handlersRun[0], equalTo(handleWithoutError));
		}

		[Test]
		public function a_blocking_handler_added_to_beforeInitializing_means_initialization_doesnt_happen():void
		{
			instance.processErrorHandler = LOG_PROCESS_ERRORS;
			instance.beforeInitializing(handleWithError);
			instance.initialize();
			assertStateIs(Lifecycle.BORN);
		}

		[Test]
		public function handlers_added_to_beforeInitializing_whenInitializing_and_afterInitializing_are_run_in_order_after_initialize():void
		{
			instance.whenInitializing(handleWithoutError2);
			instance.afterInitializing(handleWithoutError4);
			instance.beforeInitializing(handleWithoutError);
			instance.whenInitializing(handleWithoutError3);

			instance.initialize();

			const expectedToHaveRun:Array = [handleWithoutError, handleWithoutError2, handleWithoutError3, handleWithoutError4];

			assertHandlersRan(expectedToHaveRun);
		}

		[Test]
		public function handlers_added_to_beforeSuspending_whenSuspending_and_afterSuspending_are_run_in_order_after_suspend():void
		{
			instance.whenSuspending(handleWithoutError2);
			instance.afterSuspending(handleWithoutError4);
			instance.beforeSuspending(handleWithoutError);

			instance.initialize();
			instance.suspend();

			const expectedToHaveRun:Array = [handleWithoutError, handleWithoutError2, handleWithoutError4];

			assertHandlersRan(expectedToHaveRun);
		}

		[Test]
		public function handlers_added_to_beforeResuming_whenResuming_and_afterResuming_are_run_in_order_after_resume():void
		{
			instance.whenResuming(handleWithoutError2);
			instance.afterResuming(handleWithoutError4);
			instance.beforeResuming(handleWithoutError);
			instance.whenResuming(handleWithoutError3);

			instance.initialize();
			instance.suspend();
			instance.resume();

			const expectedToHaveRun:Array = [handleWithoutError, handleWithoutError2, handleWithoutError3, handleWithoutError4];

			assertHandlersRan(expectedToHaveRun);
		}

		[Test]
		public function handlers_added_to_beforeDestroying_whenDestroying_and_afterDestroying_are_run_in_order_after_destroy():void
		{
			instance.whenDestroying(handleWithoutError2);
			instance.afterDestroying(handleWithoutError4);
			instance.beforeDestroying(handleWithoutError);

			instance.initialize();
			instance.destroy();

			const expectedToHaveRun:Array = [handleWithoutError, handleWithoutError2, handleWithoutError4];

			assertHandlersRan(expectedToHaveRun);
		}

		// Callbacks are called without errors at correct timing

		[Test]
		public function callback_is_called_by_initialize_between_WHEN_and_AFTER_handlers():void
		{
			instance.beforeInitializing(handleWithoutError);
			instance.afterInitializing(handleWithoutError3);
			instance.whenInitializing(handleWithoutError2);
			instance.initialize(callback);
			const expectedToHaveRun:Array = [handleWithoutError, handleWithoutError2, callback, handleWithoutError3];
			assertHandlersRan(expectedToHaveRun);
		}

		[Test]
		public function callback_is_called_by_suspend_between_WHEN_and_AFTER_handlers():void
		{
			instance.beforeSuspending(handleWithoutError);
			instance.afterSuspending(handleWithoutError3);
			instance.whenSuspending(handleWithoutError2);
			instance.initialize();
			instance.suspend(callback);
			const expectedToHaveRun:Array = [handleWithoutError, handleWithoutError2, callback, handleWithoutError3];
			assertHandlersRan(expectedToHaveRun);
		}

		[Test]
		public function callback_is_called_by_resume_between_WHEN_and_AFTER_handlers():void
		{
			instance.beforeResuming(handleWithoutError);
			instance.afterResuming(handleWithoutError3);
			instance.whenResuming(handleWithoutError2);
			instance.initialize();
			instance.suspend();
			instance.resume(callback);
			const expectedToHaveRun:Array = [handleWithoutError, handleWithoutError2, callback, handleWithoutError3];
			assertHandlersRan(expectedToHaveRun);
		}

		[Test]
		public function callback_is_called_by_destroy_between_WHEN_and_AFTER_handlers():void
		{
			instance.beforeDestroying(handleWithoutError);
			instance.afterDestroying(handleWithoutError3);
			instance.whenDestroying(handleWithoutError2);
			instance.initialize();
			instance.destroy(callback);
			const expectedToHaveRun:Array = [handleWithoutError, handleWithoutError2, callback, handleWithoutError3];
			assertHandlersRan(expectedToHaveRun);
		}

		// Testing callbacks with no handlers added

		[Test]
		public function callback_is_called_by_initialize_when_there_are_no_handlers():void
		{
			instance.initialize(callback);
			const expectedToHaveRun:Array = [callback];
			assertHandlersRan(expectedToHaveRun);
		}

		[Test]
		public function callback_is_called_by_suspend_when_there_are_no_handlers():void
		{
			instance.initialize();
			instance.suspend(callback);
			const expectedToHaveRun:Array = [callback];
			assertHandlersRan(expectedToHaveRun);
		}

		[Test]
		public function callback_is_called_by_resume_when_there_are_no_handlers():void
		{
			instance.initialize();
			instance.suspend();
			instance.resume(callback);
			const expectedToHaveRun:Array = [callback];
			assertHandlersRan(expectedToHaveRun);
		}

		[Test]
		public function callback_is_called_by_destroy_when_there_are_no_handlers():void
		{
			instance.initialize();
			instance.destroy(callback);
			const expectedToHaveRun:Array = [callback];
			assertHandlersRan(expectedToHaveRun);
		}

		// If the before handlers error, the process is halted but the callback is run

		[Test]
		public function if_before_handlers_error_on_initialize_the_callback_is_run():void
		{
			instance.processErrorHandler = LOG_PROCESS_ERRORS;
			instance.beforeInitializing(handleWithoutError);
			instance.beforeInitializing(handleWithError);
			instance.afterInitializing(handleWithoutError3);
			instance.whenInitializing(handleWithoutError2);
			instance.initialize(callback);
			const expectedToHaveRun:Array = [handleWithoutError, handleWithError, callback];
			assertHandlersRan(expectedToHaveRun);
		}

		[Test]
		public function if_before_handlers_error_on_suspend_the_callback_is_run():void
		{
			instance.processErrorHandler = LOG_PROCESS_ERRORS;
			instance.beforeSuspending(handleWithError);
			instance.afterSuspending(handleWithoutError3);
			instance.whenSuspending(handleWithoutError2);
			instance.initialize();
			instance.suspend(callback);
			const expectedToHaveRun:Array = [handleWithError, callback];
			assertHandlersRan(expectedToHaveRun);
		}

		[Test]
		public function if_before_handlers_error_on_resume_the_callback_is_run():void
		{
			instance.processErrorHandler = LOG_PROCESS_ERRORS;
			instance.beforeResuming(handleWithoutError);
			instance.beforeResuming(handleWithError);
			instance.afterResuming(handleWithoutError3);
			instance.whenResuming(handleWithoutError2);
			instance.initialize();
			instance.suspend();
			instance.resume(callback);
			const expectedToHaveRun:Array = [handleWithoutError, handleWithError, callback];
			assertHandlersRan(expectedToHaveRun);
		}

		[Test]
		public function if_before_handlers_error_on_destroy_the_callback_is_run():void
		{
			instance.processErrorHandler = LOG_PROCESS_ERRORS;
			instance.beforeDestroying(handleWithError);
			instance.afterDestroying(handleWithoutError3);
			instance.whenDestroying(handleWithoutError2);
			instance.initialize();
			instance.destroy(callback);
			const expectedToHaveRun:Array = [handleWithError, callback];
			assertHandlersRan(expectedToHaveRun);
		}

		// If the before handlers error, the state is not changed

		[Test]
		public function if_before_handlers_error_on_initialize_the_state_is_not_changed():void
		{
			instance.processErrorHandler = LOG_PROCESS_ERRORS;
			instance.beforeInitializing(handleWithoutError);
			instance.beforeInitializing(handleWithError);
			instance.initialize();
			assertStateIs(Lifecycle.BORN)
		}

		[Test]
		public function if_before_handlers_error_on_suspend_the_state_is_not_changed():void
		{
			instance.processErrorHandler = LOG_PROCESS_ERRORS;
			instance.beforeSuspending(handleWithoutError);
			instance.beforeSuspending(handleWithError);
			instance.initialize();
			instance.suspend();
			assertStateIs(Lifecycle.ACTIVE);
		}

		[Test]
		public function if_before_handlers_error_on_resume_the_state_is_not_changed():void
		{
			instance.processErrorHandler = LOG_PROCESS_ERRORS;
			instance.beforeResuming(handleWithoutError);
			instance.beforeResuming(handleWithError);
			instance.initialize();
			instance.suspend();
			instance.resume();
			assertStateIs(Lifecycle.SUSPENDED);
		}

		[Test]
		public function if_before_handlers_error_on_destroy_the_state_is_not_changed():void
		{
			instance.processErrorHandler = LOG_PROCESS_ERRORS;
			instance.beforeDestroying(handleWithoutError);
			instance.beforeDestroying(handleWithError);
			instance.initialize();
			instance.destroy();
			assertStateIs(Lifecycle.ACTIVE);
		}

		// If the before handlers error, and a process error handler is present, errors are passed to the process error handler

		[Test]
		public function if_before_handlers_error_and_a_process_error_handler_is_present_errors_are_passed_to_it():void
		{
			instance.processErrorHandler = LOG_PROCESS_ERRORS;
			instance.beforeInitializing(handleWithoutError);
			instance.beforeInitializing(handleWithError);
			instance.initialize();
			assertErrorsReceived();
		}

		[Test(expects="robotlegs.bender.core.lifecycle.api.LifecycleError")]
		public function if_before_handlers_error_and_NO_process_error_handler_is_present_and_no_callback_is_passed_we_explode():void
		{
			instance.beforeInitializing(handleWithoutError);
			instance.beforeInitializing(handleWithError);
			instance.initialize();
		}

		[Test]
		public function if_before_handlers_error_we_pass_errors_to_the_callback():void
		{
			instance.processErrorHandler = LOG_PROCESS_ERRORS;
			instance.beforeInitializing(handleWithoutError);
			instance.beforeInitializing(handleWithError);
			instance.initialize(callback);
			assertErrorsReceived();
		}

		// check that if when handlers error, errors are passed to process error handler

		[Test]
		public function if_when_handlers_error_the_errors_are_passed_to_process_error_handler():void
		{
			instance.processErrorHandler = LOG_PROCESS_ERRORS;
			instance.beforeInitializing(handleWithoutError);
			instance.whenInitializing(handleWithError);
			instance.initialize(callback);
			assertErrorsReceived();
		}

		// check that if when handlers error, errors are not passed to callback

		[Test]
		public function if_when_handlers_error_the_errors_are_not_passed_to_the_callback():void
		{
			instance.processErrorHandler = IGNORE_PROCESS_ERRORS;
			instance.beforeInitializing(handleWithoutError);
			instance.whenInitializing(handleWithError);
			instance.initialize(callback);
			assertNoErrorsReceived();
		}

		// check that if after handlers error, errors are passed to the process error handler
		[Test]
		public function if_after_handlers_error_the_errors_are_passed_to_process_error_handler():void
		{
			instance.processErrorHandler = LOG_PROCESS_ERRORS;
			instance.beforeInitializing(handleWithoutError);
			instance.afterInitializing(handleWithError);
			instance.initialize(callback);
			assertErrorsReceived();
		}

		// check that if when handlers error, callback and after handlers still run
		[Test]
		public function if_when_handlers_error_the_callback_and_after_handlers_still_run():void
		{
			instance.processErrorHandler = IGNORE_PROCESS_ERRORS;
			instance.beforeDestroying(handleWithoutError);
			instance.whenDestroying(handleWithError);
			instance.afterDestroying(handleWithoutError3);
			instance.initialize();
			instance.destroy(callback);
			const expectedToHaveRun:Array = [handleWithoutError, handleWithError, callback, handleWithoutError3];
			assertHandlersRan(expectedToHaveRun);
		}

		// check that if early when handlers error, later when handlers still run
		[Test]
		public function if_early_when_handlers_error_then_later_when_handlers_still_run():void
		{
			instance.processErrorHandler = IGNORE_PROCESS_ERRORS;
			instance.beforeInitializing(handleWithoutError);
			instance.whenInitializing(handleWithError);
			instance.whenInitializing(handleWithoutError2);
			instance.initialize(callback);
			const expectedToHaveRun:Array = [handleWithoutError, handleWithError, handleWithoutError2, callback];
			assertHandlersRan(expectedToHaveRun);
		}

		// check that if early after handlers error, later after handlers still run
		[Test]
		public function if_early_after_handlers_error_then_later_after_handlers_still_run():void
		{
			instance.processErrorHandler = IGNORE_PROCESS_ERRORS;
			instance.beforeInitializing(handleWithoutError);
			instance.afterInitializing(handleWithError);
			instance.afterInitializing(handleWithoutError2);
			instance.initialize(callback);
			const expectedToHaveRun:Array = [handleWithoutError, callback, handleWithError, handleWithoutError2];
			assertHandlersRan(expectedToHaveRun);
		}

		// check that if early before handlers error, later before handlers do not run
		[Test]
		public function if_early_before_handlers_error_then_later_before_handlers_do_not_run():void
		{
			instance.processErrorHandler = IGNORE_PROCESS_ERRORS;
			instance.beforeInitializing(handleWithoutError);
			instance.beforeInitializing(handleWithError);
			instance.beforeInitializing(handleWithoutError2);
			instance.initialize(callback);
			const expectedToHaveRun:Array = [handleWithoutError, handleWithError, callback];
			assertHandlersRan(expectedToHaveRun);
		}

		// check that if when handlers error and there is no process error handler, error is thrown
		[Test(expects="robotlegs.bender.core.lifecycle.api.LifecycleError")]
		public function if_when_handlers_error_and_NO_process_error_handler_is_present_we_explode():void
		{
			instance.beforeInitializing(handleWithoutError);
			instance.whenInitializing(handleWithError);
			instance.initialize();
		}

		// check that if after handlers error and there is no process error handler, error is thrown
		[Test(expects="robotlegs.bender.core.lifecycle.api.LifecycleError")]
		public function if_after_handlers_error_and_NO_process_error_handler_is_present_we_explode():void
		{
			instance.beforeInitializing(handleWithoutError);
			instance.afterInitializing(handleWithError);
			instance.initialize();
		}

		// check that process error handler is passed (optional) second argument describing the transition if it requires it
		[Test]
		public function process_error_handler_is_passed_optional_second_arg_if_required_with_correct_transition():void
		{
			instance.processErrorHandler = INSPECT_PROCESS_ERRORS;
			instance.whenInitializing(handleWithError);
			instance.initialize();
			assertThat(_lifecycleMessageReceived.transition, equalTo(instance.initialize));
		}

		// check that process error handler is passed (optional) second argument describing the timing if it requires it
		[Test]
		public function process_error_handler_is_passed_optional_second_arg_if_required_with_correct_timing():void
		{
			instance.processErrorHandler = INSPECT_PROCESS_ERRORS;
			instance.whenInitializing(handleWithError);
			instance.initialize();
			assertThat(_lifecycleMessageReceived.timing, equalTo(Lifecycle.WHEN));
		}

		// check that suspend and destroy handlers are run backwards
		[Test]
		public function before_suspend_handlers_are_run_backwards():void
		{
			instance.beforeSuspending(handleWithoutError3);
			instance.beforeSuspending(handleWithoutError2);
			instance.beforeSuspending(handleWithoutError);
			instance.initialize();
			instance.suspend();
			const expectedToHaveRun:Array = [handleWithoutError, handleWithoutError2, handleWithoutError3];

			assertHandlersRan(expectedToHaveRun);
		}

		[Test]
		public function before_destroy_handlers_are_run_backwards():void
		{
			instance.beforeDestroying(handleWithoutError3);
			instance.beforeDestroying(handleWithoutError2);
			instance.beforeDestroying(handleWithoutError);
			instance.initialize();
			instance.destroy();
			const expectedToHaveRun:Array = [handleWithoutError, handleWithoutError2, handleWithoutError3];

			assertHandlersRan(expectedToHaveRun);
		}

		[Test]
		public function when_suspend_handlers_are_run_backwards():void
		{
			instance.whenSuspending(handleWithoutError3);
			instance.whenSuspending(handleWithoutError2);
			instance.whenSuspending(handleWithoutError);
			instance.initialize();
			instance.suspend();
			const expectedToHaveRun:Array = [handleWithoutError, handleWithoutError2, handleWithoutError3];

			assertHandlersRan(expectedToHaveRun);
		}

		[Test]
		public function when_destroy_handlers_are_run_backwards():void
		{
			instance.whenDestroying(handleWithoutError3);
			instance.whenDestroying(handleWithoutError2);
			instance.whenDestroying(handleWithoutError);
			instance.initialize();
			instance.destroy();
			const expectedToHaveRun:Array = [handleWithoutError, handleWithoutError2, handleWithoutError3];

			assertHandlersRan(expectedToHaveRun);
		}

		[Test]
		public function after_suspend_handlers_are_run_backwards():void
		{
			instance.afterSuspending(handleWithoutError3);
			instance.afterSuspending(handleWithoutError2);
			instance.afterSuspending(handleWithoutError);
			instance.initialize();
			instance.suspend();
			const expectedToHaveRun:Array = [handleWithoutError, handleWithoutError2, handleWithoutError3];

			assertHandlersRan(expectedToHaveRun);
		}

		[Test]
		public function after_destroy_handlers_are_run_backwards():void
		{
			instance.processErrorHandler = IGNORE_PROCESS_ERRORS;
			instance.afterDestroying(handleWithoutError3);
			instance.afterDestroying(handleWithoutError2);
			instance.afterDestroying(handleWithoutError);
			instance.initialize();
			instance.destroy();
			const expectedToHaveRun:Array = [handleWithoutError, handleWithoutError2, handleWithoutError3];

			assertHandlersRan(expectedToHaveRun);
		}

		// Passed values

		[Test]
		public function message_passed_to_handler_has_expected_transition():void
		{
			instance.whenInitializing(logHandlerMessage);
			instance.initialize();
			assertThat(_messageReceived.transition, equalTo(instance.initialize));
		}

		[Test]
		public function message_passed_to_handler_has_expected_timing():void
		{
			instance.whenInitializing(logHandlerMessage);
			instance.initialize();
			assertThat(_messageReceived.timing, equalTo(Lifecycle.WHEN));
		}

		[Test]
		public function message_passed_to_handler_has_expected_description():void
		{
			instance.whenInitializing(logHandlerMessage);
			instance.initialize();
			const expectedDescription:String = "when initializing";
			assertThat(_messageReceived.description, equalTo(expectedDescription));
		}

		[Test]
		public function message_passed_to_handler_has_expected_target():void
		{
			const targetObject:Object = {};
			const targettedInstance:Lifecycle = new Lifecycle(targetObject);
			targettedInstance.whenInitializing(logHandlerMessage);
			targettedInstance.initialize();
			assertThat(_messageReceived.target, equalTo(targetObject));
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		// Handlers

		public function handleWithoutError():void
		{
			if (inExpectedState)
				_handlersRun.push(handleWithoutError);
		}

		public function handleWithoutError2():void
		{
			if (inExpectedState)
				_handlersRun.push(handleWithoutError2);
		}

		public function handleWithoutError3():void
		{
			if (inExpectedState)
				_handlersRun.push(handleWithoutError3);
		}

		public function handleWithoutError4():void
		{
			if (inExpectedState)
				_handlersRun.push(handleWithoutError4);
		}

		public function logHandlerMessage(message:Object):void
		{
			_messageReceived = message;
		}

		public function handleWithError(message:Object, callback:Function):void
		{
			_handlersRun.push(handleWithError);
			callback(new Error('Unhappy handler says no!'));
		}

		public function callback(errors:*):void
		{
			_handlersRun.push(callback);
			_errorsReceived = errors;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		//------ CUSTOM ASSERTS

		private function assertStateIs(expectedState:LifecycleState):void
		{
			assertThat(instance.state, equalTo(expectedState));
		}

		private function assertTransitionWasInvalid():void
		{
			assertThat(_invalidTransitionAttempted, isTrue());
		}

		private function assertTransitionWasValid():void
		{
			assertThat(_invalidTransitionAttempted, isFalse());
		}

		private function assertHandlersRan(expectedToHaveRun:Array):void
		{
			assertThat(_handlersRun, array(expectedToHaveRun));
		}

		private function assertErrorsReceived():void
		{
			assertThat(_errorsReceived, notNullValue());
		}

		private function assertNoErrorsReceived():void
		{
			assertThat(_errorsReceived, nullValue());
		}

		// -------------------------- PRODUCTION CODE ----------------------------------- //

		// Sketch of possible strategies for handling invalid transitions - probably only one is
		// actually useful in final implementation, just here to help remember to choose one and
		// for testing that invalid transitions have been handled

		private function LOG_INVALID_TRANSITIONS(message:String):void
		{
			_invalidTransitionAttempted = true;
		}

		private function ERROR_ON_INVALID_TRANSITIONS(message:String):void
		{

		}

		private function WARN_ON_INVALID_TRANSITIONS(message:String):void
		{

		}

		private function IGNORE_INVALID_TRANSITIONS(message:String):void
		{
		}

		private function LOG_PROCESS_ERRORS(errors:Object):void
		{
			_errorsReceived = errors;
		}

		private function IGNORE_PROCESS_ERRORS(errors:Object):void
		{
		}

		private function INSPECT_PROCESS_ERRORS(errors:Object, lifecycleMessage:LifecycleMessage):void
		{
			_errorsReceived = errors;
			_lifecycleMessageReceived = lifecycleMessage;
		}
	}
}

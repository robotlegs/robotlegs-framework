package net.boyblack.robotlegs.core
{

	/**
	 * The interface definition for a RobotLegs MediatorFactory
	 */
	public interface IMediatorFactory
	{
		/**
		 * Map an <code>IMediator</code> to a view Class
		 * @param viewClass The view Class
		 * @param mediatorClass The <code>IMediator</code> Class
		 */
		function mapMediator( viewClass:Class, mediatorClass:Class ):void;

		/**
		 * Create an instance of a mapped <code>IMediator</code>
		 * @param viewComponent An instance of the view Class previously mapped to an <code>IMediator</code> Class
		 * @return The <code>IMediator</code>
		 */
		function createMediator( viewComponent:Object ):IMediator;

		/**
		 * Manually register an <code>IMediator</code> instance
		 * @param mediator The <code>IMediator</code> to register
		 * @param viewComponent The view component for the <code>IMediator</code>
		 */
		function registerMediator( mediator:IMediator, viewComponent:Object ):void;

		/**
		 * Remove a registered <code>IMediator</code> instance
		 * @param mediator The <code>IMediator</code> to remove
		 * @return The <code>IMediator</code> that was removed
		 */
		function removeMediator( mediator:IMediator ):IMediator;

		/**
		 * Remove a registered <code>IMediator</code> instance
		 * @param viewComponent The view that the <code>IMediator</code> was registered with
		 * @return The <code>IMediator</code> that was removed
		 */
		function removeMediatorByView( viewComponent:Object ):IMediator;

		/**
		 * Retrieve a registered <code>IMediator</code> instance
		 * @param viewComponent The view that the <code>IMediator</code> was registered with
		 * @return The <code>IMediator</code>
		 */
		function retrieveMediator( viewComponent:Object ):IMediator;

		/**
		 * Check if an <code>IMediator</code> has been registered for a view instance
		 * @param viewComponent The view that the <code>IMediator</code> was registered with
		 * @return Whether an <code>IMediator</code> has been registered for this view instance
		 */
		function hasMediator( viewComponent:Object ):Boolean;
	}
}
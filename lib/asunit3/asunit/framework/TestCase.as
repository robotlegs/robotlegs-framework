package asunit.framework {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;

	import asunit.errors.AssertionFailedError;
	import asunit.util.ArrayIterator;
	import asunit.util.Iterator;

	/**
	 * A test case defines the fixture to run multiple tests. To define a test case<br>
	 * 1) implement a subclass of TestCase<br>
	 * 2) define instance variables that store the state of the fixture<br>
	 * 3) initialize the fixture state by overriding <code>setUp</code><br>
	 * 4) clean-up after a test by overriding <code>tearDown</code>.<br>
	 * Each test runs in its own fixture so there
	 * can be no side effects among test runs.
	 * Here is an example:
	 * <listing>
	 * public class MathTest extends TestCase {
	 *      private var value1:Number;
	 *      private var value2:Number;
	 *
	 *      public function MathTest(methodName:String=null) {
	 *         super(methodName);
	 *      }
	 *
	 *      override protected function setUp():void {
	 *         super.setUp();
	 *         value1 = 2;
	 *         value2 = 3;
	 *      }
	 * }
	 * </listing>
	 *
	 * For each test implement a method which interacts
	 * with the fixture. Verify the expected results with assertions specified
	 * by calling <code>assertTrue</code> with a boolean, or <code>assertEquals</code>
	 * with two primitive values that should match.
	 * <listing>
	 *    public function testAdd():void {
	 *        var result:Number = value1 + value2;
	 *        assertEquals(5, result);
	 *    }
	 * </listing>
	 *
	 *  There are three common types of test cases:
	 *
	 *  <ol>
	 *  <li>Simple unit test</li>
	 *  <li>Visual integration test</li>
	 *  <li>Asynchronous test</li>
	 *  </ol>
	 *
	 *  @includeExample MathUtilTest.as
	 *  @includeExample ComponentTestIntroduction.as
	 *  @includeExample ComponentUnderTest.as
	 *  @includeExample ComponentTestExample.as
	 *  @includeExample AsynchronousTestMethodExample.as
	 */
	public class TestCase extends Assert implements Test {
		protected static const PRE_SET_UP:int        = 0;
		protected static const SET_UP:int             = 1;
		protected static const RUN_METHOD:int         = 2;
		protected static const TEAR_DOWN:int        = 3;
		protected static const DEFAULT_TIMEOUT:int     = 1000;

		protected var context:DisplayObjectContainer;
		protected var fName:String;
		protected var isComplete:Boolean;
		protected var result:TestListener;
		protected var testMethods:Array;

		private var asyncQueue:Array;
		private var currentMethod:String;
		private var currentState:int;
		private var layoutManager:Object;
		private var methodIterator:Iterator;
		private var runSingle:Boolean;

		/**
		 * Constructs a test case with the given name.
		 *
		 * Be sure to implement the constructor in your own TestCase base classes.
		 *
		 * Using the optional <code>testMethod</code> constructor parameter is how we
		 * create and run a single test case and test method.
		 */
		public function TestCase(testMethod:String = null) {
			var description:XML = describeType(this);
			var className:Object = description.@name;
			var methods:XMLList = description..method.(@name.match("^test"));
			if(testMethod != null) {
				testMethods = testMethod.split(", ").join(",").split(",");
				if(testMethods.length == 1) {
					runSingle = true;
				}
			} else {
				setTestMethods(methods);
			}
			setName(className.toString());
			resolveLayoutManager();
			asyncQueue = [];
		}

		private function resolveLayoutManager():void {
			// Avoid creating import dependencies on flex framework
			// If you have the framework.swc in your classpath,
			// the layout manager will be found, if not, a mcok
			// will be used.
			try {
				var manager:Class = getDefinitionByName("mx.managers.LayoutManager") as Class;
				layoutManager = manager["getInstance"]();
				if(!layoutManager.hasOwnProperty("resetAll")) {
					throw new Error("TestCase :: mx.managers.LayoutManager missing resetAll method");
				}
			}
			catch(e:Error) {
				layoutManager = new Object();
				layoutManager.resetAll = function():void {
				};
			}
		}

		/**
		 * Sets the name of a TestCase
		 * @param name The name to set
		 */
		public function setName(name:String):void {
			fName = name;
		}

		protected function setTestMethods(methodNodes:XMLList):void {
			testMethods = new Array();
			var methodNames:Object = methodNodes.@name;
			var name:String;
			for each(var item:Object in methodNames) {
				name = item.toString();
				testMethods.push(name);
			}
		}

		public function getTestMethods():Array {
			return testMethods;
		}

		/**
		 * Counts the number of test cases executed by run(TestResult result).
		 */
		public function countTestCases():int {
			return testMethods.length;
		}

		/**
		 * Creates a default TestResult object
		 *
		 * @see TestResult
		 */
		protected function createResult():TestResult {
			return new TestResult();
		}

		/**
		 * A convenience method to run this test, collecting the results with
		 * either the TestResult provided or a default, new TestResult object.
		 * Expects either:
		 * run():void // will return the newly created TestResult
		 * run(result:TestResult):TestResult // will use the TestResult
		 * that was passed in.
		 *
		 * @see TestResult
		 */
		public function run():void {
			getResult().run(this);
		}

		public function setResult(result:TestListener):void {
			this.result = result;
		}

		public function getResult():TestListener {
			return (result == null) ? createResult() : result;
		}

		/**
		 * Runs the bare test sequence.
		 * @throws Error if any exception is thrown
		 */
		public function runBare():void {
			if(isComplete) {
				return;
			}
			var name:String;
			var itr:Iterator = getMethodIterator();
			if(itr.hasNext()) {
				name = String(itr.next());
				currentState = PRE_SET_UP;
				runMethod(name);
			}
			else {
				cleanUp();
				getResult().endTest(this);
				isComplete = true;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}

		private function getMethodIterator():Iterator {
			if(methodIterator == null) {
				methodIterator = new ArrayIterator(testMethods);
			}
			return methodIterator;
		}

		/**
		*   Override this method in Asynchronous test cases
		*   or any other time you want to perform additional
		*   member cleanup after all test methods have run
		**/
		protected function cleanUp():void {
		}

		private function runMethod(methodName:String):void {
			try {
				if(currentState == PRE_SET_UP) {
					currentState = SET_UP;
					getResult().startTestMethod(this, methodName);
					setUp(); // setUp may be async and change the state of methodIsAsynchronous
				}
				currentMethod = methodName;
				if(!waitForAsync()) {
					currentState = RUN_METHOD;
					/*
					trace("");
					trace(" -------- RUNNING: " + methodName + " --------");
					trace("");
					*/
					this[methodName]();
				}
			}
			catch(assertionFailedError:AssertionFailedError) {
				getResult().addFailure(this, assertionFailedError);
			}
			catch(unknownError:Error) {
				getResult().addError(this, unknownError);
			}
			finally {
				if(!waitForAsync()) {
					runTearDown();
				}
			}
		}

		/**
		 * Sets up the fixture, for example, instantiate a mock object.
		 * This method is called before each test is executed.
		 * throws Exception on error.
		 *
		 * @example This method is usually overridden in your concrete test cases:
		 *  <listing>
		 *  private var instance:MyInstance;
		 *
		 *  override protected function setUp():void {
		 *      super.setUp();
		 *      instance = new MyInstance();
		 *      addChild(instance);
		 *  }
		 *  </listing>
		 */
		protected function setUp():void {
		}
		/**
		 *  Tears down the fixture, for example, delete mock object.
		 *
		 *  This method is called after a test is executed - even if the test method
		 *  throws an exception or fails.
		 *
		 *  Even though the base class <code>TestCase</code> doesn't do anything on <code>tearDown</code>,
		 *  It's a good idea to call <code>super.tearDown()</code> in your subclasses. Many projects
		 *  wind up using some common fixtures which can often be extracted out a common project
		 *  <code>TestCase</code>.
		 *
		 *  <code>tearDown</code> is <em>not</em> called when we tell a test case to execute
		 *  a single test method.
		 *
		 *  @throws Error on error.
		 *
		 *  @example This method is usually overridden in your concrete test cases:
		 *  <listing>
		 *  private var instance:MyInstance;
		 *
		 *  override protected function setUp():void {
		 *      super.setUp();
		 *      instance = new MyInstance();
		 *      addChild(instance);
		 *  }
		 *
		 *  override protected function tearDown():void {
		 *      super.tearDown();
		 *      removeChild(instance);
		 *  }
		 *  </listing>
		 *
		 */
		protected function tearDown():void {
		}

		/**
		 * Returns a string representation of the test case
		 */
		override public function toString():String {
			if(getCurrentMethod()) {
				return getName() + "." + getCurrentMethod() + "()";
			}
			else {
				return getName();
			}
		}
		/**
		 * Gets the name of a TestCase
		 * @return returns a String
		 */
		public function getName():String {
			return fName;
		}

		public function getCurrentMethod():String {
			return currentMethod;
		}

		public function getIsComplete():Boolean {
			return isComplete;
		}

		public function setContext(context:DisplayObjectContainer):void {
			this.context = context;
		}

		/**
		*   Returns the visual <code>DisplayObjectContainer</code> that will be used by
		*   <code>addChild</code> and <code>removeChild</code> helper methods.
		**/
		public function getContext():DisplayObjectContainer {
			return context;
		}

		/**
		*   Called from within <code>setUp</code> or the body of any test method.
		*
		*   Any call to <code>addAsync</code>, will prevent test execution from continuing
		*   until the <code>duration</code> (in milliseconds) is exceeded, or the function returned by <code>addAsync</code>
		*   is called. <code>addAsync</code> can be called any number of times within a particular
		*   test method, and will block execution until each handler has returned.
		*
		*   Following is an example of how to use the <code>addAsync</code> feature:
		*   <listing>
		*   public function testDispatcher():void {
		*       var dispatcher:IEventDispatcher = new EventDispatcher();
		*       // Subscribe to an event by sending the return value of addAsync:
		*       dispatcher.addEventListener(Event.COMPLETE, addAsync(function(event:Event):void {
		*           // Make assertions *inside* your async handler:
		*           assertEquals(34, dispatcher.value);
		*       }));
		*   }
		*   </listing>
		*
		*   If you just want to verify that a particular event is triggered, you don't
		*   need to provide a handler of your own, you can do the following:
		*   <listing>
		*   public function testDispatcher():void {
		*       var dispatcher:IEventDispatcher = new EventDispatcher();
		*       dispatcher.addEventListener(Event.COMPLETE, addAsync());
		*   }
		*   </listing>
		*
		*   If you have a series of events that need to happen, you can generally add
		*   the async handler to the last one.
		*
		*   The main thing to remember is that any assertions that happen outside of the
		*   initial thread of execution, must be inside of an <code>addAsync</code> block.
		**/
		protected function addAsync(handler:Function = null, duration:Number=DEFAULT_TIMEOUT, failureHandler:Function=null):Function {
			if(handler == null) {
				handler = function(args:*):* {return;};
			}
			var async:AsyncOperation = new AsyncOperation(this, handler, duration, failureHandler);
			asyncQueue.push(async);
			return async.getCallback();
		}

		internal function asyncOperationTimeout(async:AsyncOperation, duration:Number, isError:Boolean=true):void {
			if(isError) getResult().addError(this, new IllegalOperationError("TestCase.timeout (" + duration + "ms) exceeded on an asynchronous operation."));
			asyncOperationComplete(async);
		}

		internal function asyncOperationComplete(async:AsyncOperation):void{
			// remove operation from queue
			var i:int = asyncQueue.indexOf(async);
			asyncQueue.splice(i,1);
			// if we still need to wait, return
			if(waitForAsync()) return;
			if(currentState == SET_UP) {
				runMethod(currentMethod);
			}
			else if(currentState == RUN_METHOD) {
				runTearDown();
			}
		}

		private function waitForAsync():Boolean{
			return asyncQueue.length > 0;
		}

		protected function runTearDown():void {
			if(currentState == TEAR_DOWN) {
				return;
			}
			currentState = TEAR_DOWN;
			if(isComplete) {
				return;
			}
			if(!runSingle) {
				getResult().endTestMethod(this, currentMethod);
				tearDown();
				layoutManager.resetAll();
			}
			setTimeout(runBare, 5);
		}

		/**
		* Helper method for testing <code>DisplayObject</code>s.
		*
		* This method allows you to more easily add and manage <code>DisplayObject</code>
		* instances in your <code>TestCase</code>.
		*
		* If you are using the regular <code>TestRunner</code>, you cannot add Flex classes.
		*
		* If you are using a <code>FlexRunner</code> base class, you can add either
		* regular <code>DisplayObject</code>s or <code>IUIComponent</code>s.
		*
		* Usually, this method is called within <code>setUp</code>, and <code>removeChild</code>
		* is called from within <code>tearDown</code>. Using these methods, ensures that added
		* children will be subsequently removed, even when tests fail.
		*
		* Here is an example of the <code>addChild</code> method:
		* <listing>
		*   private var instance:MyComponent;
		*
		*   override protected function setUp():void {
		*       super.setUp();
		*       instance = new MyComponent();
		*       instance.addEventListener(Event.COMPLETE, addAsync());
		*       addChild(instance);
		*   }
		*
		*   override protected function tearDown():void {
		*       super.tearDown();
		*       removeChild(instance);
		*   }
		*
		*   public function testParam():void {
		*       assertEquals(34, instance.value);
		*   }
		* </listing>
		**/
		protected function addChild(child:DisplayObject):DisplayObject {
			return getContext().addChild(child);
		}

		/**
		* Helper method for removing added <code>DisplayObject</code>s.
		*
		* <b>Update:</b> This method should no longer fail if the provided <code>DisplayObject</code>
		* has already been removed.
		**/
		protected function removeChild(child:DisplayObject):DisplayObject {
			if(child == null) {
				return null;
			}
			try {
				return getContext().removeChild(child);
			}
			catch(e:Error) {
			}
			return null;
		}
	}
}

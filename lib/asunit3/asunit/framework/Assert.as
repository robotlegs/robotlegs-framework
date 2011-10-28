package asunit.framework {
    import asunit.errors.AssertionFailedError;
    
    import flash.utils.getQualifiedClassName;
    
    import flash.errors.IllegalOperationError;
    import flash.events.EventDispatcher;

    /**
     * A set of assert methods.  Messages are only displayed when an assert fails.
     */

    public class Assert extends EventDispatcher {
        /**
         * Protect constructor since it is a static only class
         */
        public function Assert() {
        }

        /**
         * Asserts that a condition is true. If it isn't it throws
         * an AssertionFailedError with the given message.
         */
        static public function assertTrue(...args:Array):void {
            var message:String;
            var condition:Boolean;

            if(args.length == 1) {
                message = "";
                condition = Boolean(args[0]);
            }
            else if(args.length == 2) {
                message = args[0];
                condition = Boolean(args[1]);
            }
            else {
                throw new IllegalOperationError("Invalid argument count");
            }

            if(!condition) {
                fail(message);
            }
        }
        /**
         * Asserts that a condition is false. If it isn't it throws
         * an AssertionFailedError with the given message.
         */
        static public function assertFalse(...args:Array):void {
            var message:String;
            var condition:Boolean;

            if(args.length == 1) {
                message = "";
                condition = Boolean(args[0]);
            }
            else if(args.length == 2) {
                message = args[0];
                condition = Boolean(args[1]);
            }
            else {
                throw new IllegalOperationError("Invalid argument count");
            }

            assertTrue(message, !condition);
        }
        /**
         *  Fails a test with the given message.
         *  
         *  @example This method can be called anytime you want to break out and fail
         *  the current test.
         *
         *  <listing>
         *  public function testSomething():void {
         *      var instance:MyClass = new MyClass();
         *      if(instance.foo()) {
         *          fail('The foo should not have been there');
         *      }
         *  }
         *  </listing>
         */
        static public function fail(message:String):void {
            throw new AssertionFailedError(message);
        }

        /**
        *  Asserts that the provided block throws an exception that matches
        *  the type provided.
        *
        *  <listing>
        *  public function testFailingCode():void {
        *     assertThrows(CustomError, function():void {
        *           var instance:Sprite = new Sprite();
        *           instance.callMethodThatThrows();
        *     });
        *  }
        *  </listing>
        **/
        static public function assertThrows(errorType:Class, block:Function):void {
            try {
                block.call();
                fail("assertThrows block did not throw an expected exception");
            }
            catch(e:Error) {
                if(!(e is errorType)) {
                    fail("assertThrows did not throw the expected error type, instead threw: " + getQualifiedClassName(e));
                }
            }
        }

        /**
         *  Asserts that two objects are equal. If they are not
         *  an AssertionFailedError is thrown with the given message.
         * 
         *  This assertion should be (by far) the one you use the most.
         *  It automatically provides useful information about what
         *  the failing values were.
         *
         *  <listing>
         *  public function testNames():void {
         *      var name1:String = "Federico Aubele";
         *      var name2:String = "Frederico Aubele";
         *      
         *      assertEquals(name1, name2);
         *  }
         *  </listing>
         */
        static public function assertEquals(...args:Array):void {
            var message:String;
            var expected:Object;
            var actual:Object;

            if(args.length == 2) {
                message = "";
                expected = args[0];
                actual = args[1];
            }
            else if(args.length == 3) {
                message = args[0];
                expected = args[1];
                actual = args[2];
            }
            else {
                throw new IllegalOperationError("Invalid argument count");
            }

            if(expected == null && actual == null) {
                return;
            }

            try {
                if(expected != null && expected.equals(actual)) {
                    return;
                }
            }
            catch(e:Error) {
                if(expected != null && expected == actual) {
                    return;
                }
            }

            failNotEquals(message, expected, actual);
        }
        /**
         * Asserts that an object isn't null. If it is
         * an AssertionFailedError is thrown with the given message.
         */
        static public function assertNotNull(...args:Array):void {
            var message:String;
            var object:Object;

            if(args.length == 1) {
                message = "";
                object = args[0];
            }
            else if(args.length == 2) {
                message = args[0];
                object = args[1];
            }
            else {
                throw new IllegalOperationError("Invalid argument count");
            }

            assertTrue(message, object != null);
        }
        /**
         * Asserts that an object is null.  If it is not
         * an AssertionFailedError is thrown with the given message.
         */
        static public function assertNull(...args:Array):void {
            var message:String;
            var object:Object;

            if(args.length == 1) {
                message = "";
                object = args[0];
            }
            else if(args.length == 2) {
                message = args[0];
                object = args[1];
            }
            else {
                throw new IllegalOperationError("Invalid argument count");
            }

            assertTrue(message, object == null);
        }
        /**
         * Asserts that two objects refer to the same object. If they are not
         * an AssertionFailedError is thrown with the given message.
         */
        static public function assertSame(...args:Array):void {
            var message:String;
            var expected:Object;
            var actual:Object;

            if(args.length == 2) {
                message = "";
                expected = args[0];
                actual = args[1];
            }
            else if(args.length == 3) {
                message = args[0];
                expected = args[1];
                actual = args[2];
            }
            else {
                throw new IllegalOperationError("Invalid argument count");
            }

            if(expected === actual) {
                return;
            }
            failNotSame(message, expected, actual);
        }
         /**
          * Asserts that two objects do not refer to the same object. If they do,
          * an AssertionFailedError is thrown with the given message.
          */
        static public function assertNotSame(...args:Array):void {
            var message:String;
            var expected:Object;
            var actual:Object;

            if(args.length == 2) {
                message = "";
                expected = args[0];
                actual = args[1];
            }
            else if(args.length == 3) {
                message = args[0];
                expected = args[1];
                actual = args[2];
            }
            else {
                throw new IllegalOperationError("Invalid argument count");
            }

            if(expected === actual)
                failSame(message);
        }

        /**
         * Asserts that two numerical values are equal within a tolerance range.
         * If they are not an AssertionFailedError is thrown with the given message.
         */
        static public function assertEqualsFloat(...args:Array):void {
            var message:String;
            var expected:Number;
            var actual:Number;
            var tolerance:Number = 0;

            if(args.length == 3) {
                message = "";
                expected = args[0];
                actual = args[1];
                tolerance = args[2];
            }
            else if(args.length == 4) {
                message = args[0];
                expected = args[1];
                actual = args[2];
                tolerance = args[3];
            }
            else {
                throw new IllegalOperationError("Invalid argument count");
            }
            if (isNaN(tolerance)) tolerance = 0;
            if(Math.abs(expected - actual) <= tolerance) {
                   return;
            }
            failNotEquals(message, expected, actual);
        }

        /**
         * Asserts that two arrays have the same length and contain the same
         * objects in the same order. If the arrays are not equal by this
         * definition an AssertionFailedError is thrown with the given message.
         */
        static public function assertEqualsArrays(...args:Array):void {
            var message:String;
            var expected:Array;
            var actual:Array;

            if(args.length == 2) {
                message = "";
                expected = args[0];
                actual = args[1];
            }
            else if(args.length == 3) {
                message = args[0];
                expected = args[1];
                actual = args[2];
            }
            else {
                throw new IllegalOperationError("Invalid argument count");
            }
            
            if (expected == null && actual == null) {
                return;
            }
            if ((expected == null && actual != null) || (expected != null && actual == null)) {
                failNotEquals(message, expected, actual);
            }
            // from here on: expected != null && actual != null
            if (expected.length != actual.length) {
                failNotEquals(message, expected, actual);
            }
            for (var i : int = 0; i < expected.length; i++) {
                assertEquals(expected[i], actual[i]);
            }
        }
        

		static public function assertEqualsVectorsIgnoringOrder(...args:Array):void {
			var message:String;
            var expected:Vector.<*>;
            var actual:Vector.<*>;

            if(args.length == 2) {
                message = "";
                expected = Vector.<*>(args[0]);
                actual = Vector.<*>(args[1]);
            }
            else if(args.length == 3) {
                message = args[0];
                expected = Vector.<*>(args[1]);
                actual = Vector.<*>(args[2]);
            }
            else {
                throw new IllegalOperationError("Invalid argument count");
            }

            var expected_array:Array = [];
			for each(var expectedItem:* in expected)
		   	{
				expected_array.push(expectedItem);
			}
			
			var actual_array:Array = [];
			for each(var actualItem:* in actual)
			{
				actual_array.push(actualItem);
			}
			
			assertEqualsArraysIgnoringOrder(message, expected_array, actual_array);
		}

        /**
         * Asserts that two arrays have the same length and contain the same
         * objects. The order of the objects in the arrays is ignored. If they
         * are not equal by this definition an AssertionFailedError is thrown
         * with the given message.
         */
        static public function assertEqualsArraysIgnoringOrder(...args:Array):void {
            var message:String;
            var expected:Array;
            var actual:Array;

            if(args.length == 2) {
                message = "";
                expected = args[0];
                actual = args[1];
            }
            else if(args.length == 3) {
                message = args[0];
                expected = args[1];
                actual = args[2];
            }
            else {
                throw new IllegalOperationError("Invalid argument count");
            }

            if (expected == null && actual == null) {
                return;
            }
            if ((expected == null && actual != null) || (expected != null && actual == null)) {
                failNotEquals(message, expected, actual);
            }
            // from here on: expected != null && actual != null
            if (expected.length != actual.length) {
                failNotEquals(message, expected, actual);
            }
            for (var i : int = 0; i < expected.length; i++) {
                var foundMatch : Boolean = false;
                var expectedMember : Object = expected[i];
                for (var j : int = 0; j < actual.length; j++) {
                    var actualMember : Object = actual[j];
                    try {
                        assertEquals(expectedMember, actualMember);
                        foundMatch = true;
                        break;
                    }
                    catch (e : AssertionFailedError) {
                        //  no match, try next
                    }
                }
                if (!foundMatch) {
                    failNotEquals("Found no match for " + expectedMember + ";", expected, actual);
                }
            }
        }


        static private function failSame(message:String):void {
            var formatted:String = "";
             if(message != null) {
                 formatted = message + " ";
             }
             fail(formatted + "expected not same");
        }

        static private function failNotSame(message:String, expected:Object, actual:Object):void {
            var formatted:String = "";
            if(message != null) {
                formatted = message + " ";
            }
            fail(formatted + "expected same:<" + expected + "> was not:<" + actual + ">");
        }

        static private function failNotEquals(message:String, expected:Object, actual:Object):void {
            fail(format(message, expected, actual));
        }

        static private function format(message:String, expected:Object, actual:Object):String {
            var formatted:String = "";
            if(message != null) {
                formatted = message + " ";
            }
            return formatted + "expected:<" + expected + "> but was:<" + actual + ">";
        }
    }
}

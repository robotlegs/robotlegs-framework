package asunit.util {
    import asunit.errors.UnimplementedFeatureError;
    import flash.errors.IllegalOperationError;

    [ExcludeClass]
    public dynamic class Properties {

        public function store(sharedObjectId:String):void {
            throw new UnimplementedFeatureError("Properties.store");
        }

        public function put(key:String, value:Object):void {
            this[key] = value;
        }

        public function setProperty(key:String, value:Object):void {
            put(key, value);
        }

        public function getProperty(key:String):Object {
            try {
                return this[key];
            }
            catch(e:Error) {
                throw IllegalOperationError("Properties.getProperty");
            }
            return null;
        }
    }
}
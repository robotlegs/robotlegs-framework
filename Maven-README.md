Maven build instructions
=====


__Step 1: Install Swift Suspenders locally__


	mvn install:install-file -Dfile=lib/SwiftSuspenders-v2.0.0b1.swc -DartifactId=swiftsuspenders -DgroupId=org.swiftsuspenders -Dversion=2.0.0-b1 -Dpackaging=swc
	
__Step 2: Install AS3Commons Logging locally__

	mvn install:install-file -Dfile=lib/as3commons-logging-2.7.swc -DartifactId=as3commons-logging -DgroupId=org.as3commons -Dversion=2.7 -Dpackaging=swc
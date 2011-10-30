Maven build instructions
=====

Dependencies to install locally:
------

1. Swift Suspenders

	mvn install:install-file -Dfile=lib/SwiftSuspenders-v2.0.0b1.swc -DartifactId=swiftsuspenders -DgroupId=org.swiftsuspenders -Dversion=2.0.0-b1 -Dpackaging=swc
	
2. Install AS3Commons Logging locally

	mvn install:install-file -Dfile=lib/as3commons-logging-2.7.swc -DartifactId=as3commons-logging -DgroupId=org.as3commons -Dversion=2.7 -Dpackaging=swc
	
3. Install FlexUnit 4.1.0-8

	mvn install:install:file -Dfile=lib/flexunit-4.1.0-8-flex_4.1.0.16076.swc -DgroupId=com.adobe.flexunit -DartifactId=flexunit -Dversion=4.1.0-8 -Dpackaging=swc -Dclassifier=flex



__Step 4: Install hamcrest-as3 locally__

	mvn install:install-file -Dfile=lib/hamcrest-as3-flex-1.1.3.swc -DgroupId=org.hamcrest -DartifactId=hamcrest-as3 -Dversion=1.1.3 -Dpackaging=swc -Dclassifier=flex
	
__Step 5: Install mockolate locally__

	mvn install:install-file -Dfile=lib/mockolate-0.12.1-flex.swc -Dversion=0.12.1 -Dclassifier=flex -Dpackaging=swc -DgroupId=mockolate -DartifactId=mockolate
	
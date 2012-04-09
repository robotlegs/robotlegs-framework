#!/bin/bash
mvn -s settings.xml install:install-file -Dfile=lib/Swiftsuspenders-v2.0.0b3.swc -DartifactId=swiftsuspenders -DgroupId=org.swiftsuspenders -Dversion=2.0.0-b3 -Dpackaging=swc
mvn -s settings.xml install:install-file -Dfile=lib/as3commons-logging-2.7.swc -DartifactId=as3commons-logging -DgroupId=org.as3commons -Dversion=2.7 -Dpackaging=swc
mvn -s settings.xml install:install-file -Dfile=lib/flexunit-4.1.0-8-flex_4.1.0.16076.swc -DgroupId=com.adobe.flexunit -DartifactId=flexunit -Dversion=4.1.0-8 -Dpackaging=swc -Dclassifier=flex
mvn -s settings.xml install:install-file -Dfile=lib/hamcrest-as3-flex-1.1.3.swc -DgroupId=org.hamcrest -DartifactId=hamcrest-as3 -Dversion=1.1.3 -Dpackaging=swc -Dclassifier=flex
mvn -s settings.xml install:install-file -Dfile=lib/mockolate-0.12.2-flex.swc -Dversion=0.12.2 -Dclassifier=flex -Dpackaging=swc -DgroupId=mockolate -DartifactId=mockolate
mvn -s settings.xml install:install-file -Dfile=lib/robotlegs-framework-v1.5.2.swc -Dversion=1.5.2 -Dpackaging=swc -DgroupId=org.robotlegs -DartifactId=robotlegs-framework

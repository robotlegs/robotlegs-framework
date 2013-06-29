call mvn -s settings.xml install:install-file -Dfile=lib/Swiftsuspenders-v2.0.0rc3.swc -DartifactId=swiftsuspenders -DgroupId=org.swiftsuspenders -Dversion=2.0.0-rc3 -Dpackaging=swc
call mvn -s settings.xml install:install-file -Dfile=lib/flexunit-4.1.0-8-flex_4.1.0.16076.swc -DgroupId=com.adobe.flexunit -DartifactId=flexunit -Dversion=4.1.0-8 -Dpackaging=swc -Dclassifier=flex
call mvn -s settings.xml install:install-file -Dfile=lib/hamcrest-as3-flex-1.1.3.swc -DgroupId=org.hamcrest -DartifactId=hamcrest-as3 -Dversion=1.1.3 -Dpackaging=swc -Dclassifier=flex
call mvn -s settings.xml install:install-file -Dfile=lib/mockolate-0.12.4-flex.swc -Dversion=0.12.4 -Dclassifier=flex -Dpackaging=swc -DgroupId=mockolate -DartifactId=mockolate

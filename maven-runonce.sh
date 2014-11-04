#!/bin/bash
mvn -s settings.xml install:install-file -Dfile=build/libs/SwiftSuspenders-v1.6.0.swc -DartifactId=swiftsuspenders -DgroupId=org.swiftsuspenders -Dversion=1.6.0 -Dpackaging=swc

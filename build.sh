#!/bin/bash
mxmlc -debug -default-background-color=#FFFFFF -default-frame-rate=24 -default-size 900 550 -library-path+=lib/hamcrest-as3-flex-1.1.3.swc -library-path+=lib/Swiftsuspenders-v2.0.0rc3.swc -library-path+=lib/mockolate-0.12.4-flex.swc -library-path+=lib/flexunit-4.1.0-8-flex_4.1.0.16076.swc -library-path+=lib/flexunit-cilistener-4.1.0-8-4.1.0.16076.swc -library-path+=lib/fluint-extensions-4.1.0-8-4.1.0.16076.swc -output=bin/Robotlegs2Runner.swf -source-path+=src -source-path+=test -verbose-stacktraces=true -warnings=true test/RobotlegsTest.mxml

ERRORLEVEL=$?
if [ $ERRORLEVEL -eq 0 ]
then
  echo
  echo ----------------------INSTRUCTIONS----------------------
  echo Compiled, now running...
  echo Type \"continue\" - no quotes - followed by return to start
  echo   Note: May need to entry \"continue\" command twice
  echo Type \"quit\" - no quotes - followed by return key to exit
  echo
  echo Note: These tests require FlashPlayer 10.1
  echo
  fdb bin/Robotlegs2Runner.swf
else
  echo
  echo -------------------INSTRUCTIONS-------------------
  if [ $ERRORLEVEL -eq 1 ]
  then
    echo Found $ERRORLEVEL error during compilation
  else
    echo Found $ERRORLEVEL errors during compilation
  fi
  echo Fix the errors indicated above then try this again.
  echo
  echo
fi
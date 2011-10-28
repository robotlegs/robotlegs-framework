#!/usr/bin/env ruby
require 'rubygems'
require 'sprout'
sprout 'sprout-as3-bundle'

# Add a class name if TestSuites were generated
if(ARGV.size == 1 && ARGV[0] == 'suite')
  ARGV << 'AllTests'
end

# Insert class type by default
if(ARGV.size == 1)
  ARGV.unshift('class')
end

# Execute generators like this:
# script/generate class utils.MathUtil
# script/generate suite
# script/generate test utils.MathUtilTest

Sprout::Sprout.generate('as3', ARGV.shift, ARGV, File.dirname(File.dirname(__FILE__)))

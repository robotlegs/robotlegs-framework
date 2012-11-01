# Code metric tools

## checkASDocs.rb

Does a crude check of whether each public function in each code file has a comment block immediately ahead of it.

__Usage:__

`ruby tools/checkASDocs.rb src`

Will list out functions requiring comment blocks.

`ruby tools/checkASDocs.rb src true`

Will list out functions which have comment blocks.

_Note: No attempt is made to verify whether all parameters, return values and so on are covered. The block may not even be ASDoc compatible, and the content of the block might be gibberish._

--
--  AppDelegate.applescript
--  test
--
--  Copyright (c) 2012 MJ Lyco LLC. (http://mjlyco.com)
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.


try
	set KeepWindows to do shell script "defaults read com.apple.finder NSQuitAlwaysKeepsWindows"
	do shell script "defaults write com.apple.finder NSQuitAlwaysKeepsWindows TRUE"
	
	tell application "Finder" to quit
    do shell script "defaults write com.apple.finder AppleShowAllFiles TRUE"
    
	delay 1
	
	tell application "Finder" to activate
	
	if KeepWindows = "FALSE" then
		do shell script "defaults write com.apple.finder NSQuitAlwaysKeepsWindows FALSE"
	end if
    
    delay 1
    tell application "Finder" to activate
	
end try
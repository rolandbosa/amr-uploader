amr-uploader
============

A ruby script to automatically upload your WoW bag contents to www.askmrrobot.com.

How to get it running
---------------------

Run bundler to install the required dependencies:

    bundle install

Edit the location of your World of Warcraft folder inside amr.rb:

    emacs amr.rb

You will also need a file with the cookies from an authenticated
session with askmrrobot.com. I used Google Chrome and install the
'Export cookie.txt' addon. The extension is small and provides exactly
the format needed for curl.

    http://www.google.com/chrome

    https://code.google.com/p/cookie-txt-export/

Save your cookies alongside the script in a file called
'cookies.txt'. If you use a different filename, update the amr.rb
script variable $COOKIES_PATH.

Now you should be able to run the script and it will upload the Lua
file as it gets modified:

    ./amr.rb

Credits
-------

The guts of this script are (shamelessly) taken from a thread on Ask
Mr. Robot's forums:

    http://forums.askmrrobot.com/index.php?topic=5102.0

No gems were hurt while writing this script.

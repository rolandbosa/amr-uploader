amr-uploader
============

A ruby script to automatically upload your WoW bag contents to www.askmrrobot.com.

How to get it running
---------------------

Run bundler to install the required dependencies:

    bundle install

Edit the location of your World of Warcraft folder inside amr.rb:

    emacs amr.rb

You also need a file with the proper cookies from an authenticated
session with www.askmrrobot.com.

I used Google Chrome and installed the 'Export cookie.txt' addon. The
extension is small and provides exactly the format needed for curl.

    http://www.google.com/chrome

    https://code.google.com/p/cookie-txt-export/

Save your cookies to a file named 'cookies.txt'. If you use a
different filename, update the amr.rb script variable $COOKIES_PATH
accordingly.

Now you should be able to run the script and it will upload the Lua
file as it gets modified:

    ./amr.rb

Your mileage may vary with 'exotic' realms like "Kill'Jaeden"
(contains an apostrophy) or "Altar of Storms" (contains spaces). What
I'm saying here is - I haven't tested it with those realms. Also, if
your character has weird umlauts - who knows what will happen ;-).


Credits
-------

The guts of this script are (shamelessly) taken from a thread on Ask
Mr. Robot's forums:

    http://forums.askmrrobot.com/index.php?topic=5102.0

No gems were hurt while writing this script.

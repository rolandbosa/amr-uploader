#!/usr/bin/env ruby

# amr-uploader
#
# This script will monitor World of Warcrafts addon folder and upload
# new bag data to the AskMrRobot website. It is similar to the Windows
# application with the same purpose, but this one is meant for OSX
# (10.8 or later).

require 'listen'
require 'json'
require 'terminal-notifier'
require 'digest/md5'

#---------------------------------------------------------------------

# Set this to the 'Account' folder inside your WoW installation
$WOW_PATH = '/Applications/World of Warcraft/WTF/Account'

# Set this to your current region - for me, this is 'USA'. Mr Robot
# wants to know this...
$REGION = 'USA'

# Log on to Mr. Robot's website using Chrome, use the 'cookie.txt
# export' plugin to save the cookies to a text file. Store the (path
# and) filename of that file here.
$COOKIES_PATH = 'cookies.txt'

#---------------------------------------------------------------------

# Should each upload create an entry in the notification center?
$TERM_ENABLE = true

# The title/subtitle of the notification
$TERM_TITLE = "Mr. Robot"
$TERM_SUBTITLE = "Bag Contents Uploader"

#---------------------------------------------------------------------

puts %q{Mr. Robot Bag Uploader V0.1
---------------------------

Use the Mr. Robot Addon inside WoW. The contents will be uploaded to the
website automatically.

To stop, press CTRL-C while the Terminal Window is active.
}

if not File.exist?($COOKIES_PATH) then
  puts %q{Ooops! It seems you don't have the cookies file. I can't upload
anything without that file. Go read the readme on how to create
it, then store it as '#{$COOKIES_PATH}'}
  exit 1
end

if not File.exist?($WOW_PATH) then
  puts %q{Ooops! It seems that your World of Warcraft folder is somewhere
else. Let me know by editing the source and setting the proper path
in the variable $WOW_PATH. Right now, I'm thinking it should be here:
#{$WOW_PATH} - but that folder doesn't exist!}
  exit 1
end

$CACHE = {}

Listen.to!($WOW_PATH,
           :filter => /.*\/AskMrRobot.lua$/,
           :relative_paths => true) do |m,a,d|
  m.each do |relative_path|

    full_path = File.join($WOW_PATH, relative_path)
    digest = Digest::MD5.hexdigest(File.read(full_path))

    split_path = relative_path.split('/')
    realm = split_path[1]
    character = split_path[2]

    print "Checking #{character} of #{realm} (MD5: #{digest})..."
    if not $CACHE.has_key?(relative_path) or $CACHE[relative_path] != digest then
      print "Uploading..."
      STDOUT.flush
      curl = "curl --silent " +
        "--form savedVariables=@\"#{full_path}\" " +
        "--form region=#{$REGION} " +
        "--form realm=#{realm} " +
        "--form name=#{character} " +
        "--cookie #{$COOKIES_PATH} " +
        "http://www.askmrrobot.com/wow/account/inventoryuploadform"
      result = JSON.parse(%x{ #{curl} })
      if result["HasError"] then
        TerminalNotifier.notify("There was an error: #{result}",
                                :title => $TERM_TITLE,
                                :subtitle => $TERM_SUBTITLE)
        puts "The server returned an error: #{result}"
      else
        TerminalNotifier.notify("Uploaded #{character} of #{realm}",
                                :title => $TERM_TITLE,
                                :subtitle => $TERM_SUBTITLE,
                                :sound => 'default')
        $CACHE[relative_path] = digest
        puts "Finished."
      end
    else
      puts "Same digest as before, skipping."
    end
  end
end

# smart_colored

Color and formatting in terminal

## Synopsis

    require 'smart_colored'

    puts 'important'.colored.red
    puts 'important'.colored.bold
    puts 'important'.colored.red.bold
    puts 'important'.colored.red_bold
    puts 'important'.colored.red_bold_on_yellow

or

    require 'smart_colored/extend'

    puts 'important'.red
    puts 'important'.bold
    puts 'important'.red.bold
    puts 'important'.red_bold
    puts 'important'.red_bold_on_yellow

output for both (colors may vary :) )

<pre>
<span style="color:red">important</span>
<span style="font-weight:bold">important</span>
<span style="color:red; font-weight:bold">important</span>
<span style="color:red; font-weight:bold">important</span>
<span style="color:red; font-weight:bold; background: yellow">important</span>
</pre>

smart means you can apply format to string which already got formatting

    require 'smart_colored/extend'

    puts "sometimes there could be #{'very important'.bold.underline} text in simply important one".red
    puts "white, #{'underlined red'.underline.red}, #{'inversed with background green'.inverse_green} and #{'bold blue'.bold_blue} on black background".white.on_black

<pre>
<span style="color:red">sometimes there could be <span style="font-weight:bold; text-decoration:underline">very important</span> text in simply important one</span>
<span style="color:white; background: black">white, <span style="color:red; text-decoration:underline">underlined red</span>, <span style="color:black; background:green">inversed with background green</span> and <span style="color:blue; font-weight:bold">bold blue</span> on black background</span>
</pre>

## Copyright

Copyright (c) 2010 Ivan Kuchin. See LICENSE.txt for details.

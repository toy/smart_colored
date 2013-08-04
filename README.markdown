# smart_colored

Color and formatting in terminal

[![Build Status](https://travis-ci.org/toy/smart_colored.png?branch=master)](https://travis-ci.org/toy/smart_colored)

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

smart means you can apply format to string which already got formatting

    require 'smart_colored/extend'

    puts "sometimes there could be #{'very important'.bold.underline} text in simply important one".red
    puts "white, #{'underlined red'.underline.red}, #{'inversed with background green'.inverse_green} and #{'bold blue'.bold_blue} on black background".white.on_black

## Copyright

Copyright (c) 2010-2011 Ivan Kuchin. See LICENSE.txt for details.

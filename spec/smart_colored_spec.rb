require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SmartColored do
  describe "proxied" do
    it "should work" do
      'bold red on green'.colored.bold_red_on_green.should == "\e[1;31;42m" 'bold red on green' "\e[0m"
    end

    it "should return String subclass" do
      'bold red on green'.colored.should be_instance_of(SmartColored::String)
    end

    it "should return String subclass after applying" do
      'bold red on green'.colored.red.should be_instance_of(SmartColored::String)
    end
  end

  describe "simple" do
    it "should apply none" do
      'clear'.apply_format.should == 'clear'
    end

    it "should apply color" do
      'red'.red.should == "\e[31m" 'red' "\e[0m"
    end

    it "should apply background" do
      'red'.on_red.should == "\e[41m" 'red' "\e[0m"
    end

    it "should apply bold" do
      'bold'.bold.should == "\e[1m" 'bold' "\e[0m"
    end

    it "should apply underline" do
      'underlined'.underline.should == "\e[4m" 'underlined' "\e[0m"
    end

    it "should apply inverse" do
      'inversed'.inverse.should == "\e[7m" 'inversed' "\e[0m"
    end
  end

  describe "combining" do
    it "should apply red and blue" do
      'red'.red.blue.should == "\e[31m" 'red' "\e[0m"
    end

    it "should apply red and bold" do
      'red'.red.bold.should == "\e[1;31m" 'red' "\e[0m"
    end

    it "should apply bold and red" do
      'red'.bold.red.should == "\e[1;31m" 'red' "\e[0m"
    end

    it "should apply red on blue" do
      'red on blue'.red.on_blue.should == "\e[31;44m" 'red on blue' "\e[0m"
    end

    it "should apply bold and underline" do
      'bold underlined'.bold.underline.should == "\e[1;4m" 'bold underlined' "\e[0m"
    end

    it "should apply bold, underlined and cyan" do
      'bold underlined cyan'.bold.underline.cyan.should == "\e[1;4;36m" 'bold underlined cyan' "\e[0m"
    end
  end

  describe "combined methods" do
    it "should apply red and blue" do
      'red'.red_blue.should == "\e[34m" 'red' "\e[0m"
    end

    it "should apply red and bold" do
      'red'.bold_red.should == "\e[1;31m" 'red' "\e[0m"
    end

    it "should apply red on blue" do
      'red on blue'.red_on_blue.should == "\e[31;44m" 'red on blue' "\e[0m"
    end

    it "should apply bold and underline" do
      'bold underlined'.bold_underline.should == "\e[1;4m" 'bold underlined' "\e[0m"
    end

    it "should apply bold, underlined and cyan" do
      'bold underlined cyan'.bold_underline_cyan.should == "\e[1;4;36m" 'bold underlined cyan' "\e[0m"
    end

    it "should apply bold, underlined, cyan on yellow" do
      %w[bold underlined cyan on_yellow].permutation.each do |parts|
        'bold underlined cyan'.send(parts.join('_')).should == "\e[1;4;36;43m" 'bold underlined cyan' "\e[0m"
      end
    end
  end

  describe "complex" do
    it "should apply blue on string with red" do
      'red'.red.should == "\e[31m" 'red' "\e[0m"
      "blue #{'red'.red} blue".blue.should == "\e[34m" 'blue ' "\e[31m" 'red' "\e[34m" ' blue' "\e[0m"
    end

    it "should apply red on string with red" do
      'red'.red.should == "\e[31m" 'red' "\e[0m"
      "red #{'red'.red} red".red.should == "\e[31m" 'red red red' "\e[0m"
    end

    it "should apply bold on string with red applied on string with bold" do
      'bold'.bold.should == "\e[1m" 'bold' "\e[0m"
      "red #{'bold'.bold} red".red.should == "\e[31m" 'red ' "\e[1m" 'bold' "\e[0;31m" ' red' "\e[0m"
      "bold #{"red #{'bold'.bold} red".red} bold".bold.should == "\e[1m" 'bold ' "\e[31m" 'red bold red' "\e[0;1m" ' bold' "\e[0m"
    end

    it "should apply bald and red on string with red applied on string with bold and red" do
      'bold red'.bold.red.should == "\e[1;31m" 'bold red' "\e[0m"
      "red #{'bold red'.bold.red} red".red.should == "\e[31m" 'red ' "\e[1m" 'bold red' "\e[0;31m" ' red' "\e[0m"
      "bold #{"red #{'bold red'.bold.red} red".red} bold".bold.red.should == "\e[1;31m" 'bold red bold red red bold' "\e[0m"
    end

    it "should apply green on string with blue applied on string with red (moved left)" do
      'red'.red.should == "\e[31m" 'red' "\e[0m"
      "#{'red'.red} blue".blue.should == "\e[31m" 'red' "\e[34m" ' blue' "\e[0m"
      "#{"#{'red'.red} blue".blue} green".green.should == "\e[31m" 'red' "\e[34m" ' blue' "\e[32m" ' green' "\e[0m"
    end

    it "should apply green on string with blue applied on string with red (moved right)" do
      'red'.red.should == "\e[31m" 'red' "\e[0m"
      "blue #{'red'.red}".blue.should == "\e[34m" 'blue ' "\e[31m" 'red' "\e[0m"
      "green #{"blue #{'red'.red}".blue}".green.should == "\e[32m" 'green ' "\e[34m" 'blue ' "\e[31m" 'red' "\e[0m"
    end

    it "should apply blue.inversed on string with on_yellow applied on string with red.underline and string with bold.red" do
      'red underlined'.red.underline.should == "\e[4;31m" 'red underlined' "\e[0m"
      "bold red".bold.red.should == "\e[1;31m" 'bold red' "\e[0m"
      "on yellow #{'red underlined'.red.underline} on yellow".on_yellow.should == "\e[43m" 'on yellow ' "\e[4;31m" 'red underlined' "\e[0;43m" ' on yellow' "\e[0m"
      "#{"on yellow #{'red underlined'.red.underline} on yellow".on_yellow} #{"bold red".bold.red} blue inversed".blue.inverse.should == "\e[7;34;43m" 'on yellow ' "\e[4;31m" 'red underlined' "\e[0;7;34;43m" ' on yellow' "\e[0;7;34m" ' ' "\e[1;31m" 'bold red' "\e[0;7;34m" ' blue inversed' "\e[0m"
    end
  end
end

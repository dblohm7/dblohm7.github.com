# Title: Clickable Image tag for Jekyll
# Authors: Brandon Mathis http://brandonmathis.com
#          Felix Schäfer, Frederic Hemberger
#          Aaron Klotz
# Description: Easily output images with optional class names, width, height, title and alt attributes. Clicking on the image opens it.
#
# Syntax {% clkimg [class name(s)] [http[s]:/]/path/to/image [width [height]] [title text | "title text" ["alt text"]] %}
#
# Examples:
# {% clkimg /images/ninja.png Ninja Attack! %}
# {% clkimg left half http://site.com/images/ninja.png Ninja Attack! %}
# {% clkimg left half http://site.com/images/ninja.png 150 150 "Ninja Attack!" "Ninja in attack posture" %}
#
# Output:
# <a href="/images/ninja.png"><img src="/images/ninja.png"></a>
# <a href="http://site.com/images/ninja.png"><img class="left half" src="http://site.com/images/ninja.png" title="Ninja Attack!" alt="Ninja Attack!"></a>
# <a href="http://site.com/images/ninja.png"><img class="left half" src="http://site.com/images/ninja.png" width="150" height="150" title="Ninja Attack!" alt="Ninja in attack posture"></a>
#

module Jekyll

  class ClkImageTag < Liquid::Tag
    @img = nil

    def initialize(tag_name, markup, tokens)
      attributes = ['class', 'src', 'width', 'height', 'title']

      if markup =~ /(?<class>\S.*\s+)?(?<src>(?:https?:\/\/|\/|\S+\/)\S+)(?:\s+(?<width>\d+))?(?:\s+(?<height>\d+))?(?<title>\s+.+)?/i
        @img = attributes.reduce({}) { |img, attr| img[attr] = $~[attr].strip if $~[attr]; img }
        if /(?:"|')(?<title>[^"']+)?(?:"|')\s+(?:"|')(?<alt>[^"']+)?(?:"|')/ =~ @img['title']
          @img['title']  = title
          @img['alt']    = alt
        else
          @img['alt']    = @img['title'].gsub!(/"/, '&#34;') if @img['title']
        end
        @img['class'].gsub!(/"/, '') if @img['class']
      end
      super
    end

    def render(context)
      if @img
        "<a href=\"#{@img['src']}\"><img #{@img.collect {|k,v| "#{k}=\"#{v}\"" if v}.join(" ")}></a>"
      else
        "Error processing input, expected syntax: {% clkimg [class name(s)] [http[s]:/]/path/to/image [width [height]] [title text | \"title text\" [\"alt text\"]] %}"
      end
    end
  end
end

Liquid::Template.register_tag('clkimg', Jekyll::ClkImageTag)

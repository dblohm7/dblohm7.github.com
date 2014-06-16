# add +gem 'rest-client', '1.6.7', :require => 'rest_client' to Gemfile
# drop this file into plugins
# use {%bug ######%} or {%Bug ######%} for capitalization
 
 
require 'rest_client'
require 'json'
 
module Bugzilla
  SERVER = "https://api-dev.bugzilla.mozilla.org/1.2/"
  @network_is_busted = false
   
  def Bugzilla.bug (bug_no)
    url = Bugzilla::SERVER + "bug/#{bug_no}"
    file = "/tmp/bug.#{bug_no}"
    begin
      response = File.read file
    rescue Errno::ENOENT
      print "fetching #{url}\n"
      response = ""
      if not @network_is_busted then
        begin
          response = ::RestClient.get url
          # handle timeouts, etc
        rescue
          network_is_busted = true;
          print "Failed to fetch #{url}. @network_is_busted time\n"
        end
      end
      response = '{"summary":""}' if @network_is_busted
      ::File.open(file, 'w') {|f| f.write(response.to_str) }
    end
    return JSON.parse(response)
  end
end
 
module Jekyll
  class Bugzilla < Liquid::Tag
    @bugno = ""
    @tagname = ""
    @extra = ""
    @title = ""

    def initialize(tagname, bugno, tokens)
      @tagname = tagname.strip()
      cmd = bugno.split(' ')
      @bugno = cmd[0]
      bug = ::Bugzilla.bug(@bugno)
      @extra = ""
      if cmd.length > 1 then
        @extra = ": " + bug[cmd[1]]
      end
      @title = "title=\"" + bug["summary"] + "\""
    end
     
    def render(conbugno)
      "<a #{@title} href=\"https://bugzilla.mozilla.org/show_bug.cgi?id=#{@bugno}\">#{@tagname} #{@bugno}</a>" + @extra
    end
  end
end
 
Liquid::Template.register_tag('bug', Jekyll::Bugzilla)
Liquid::Template.register_tag('Bug', Jekyll::Bugzilla)


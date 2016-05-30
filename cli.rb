require 'thor'
require 'dotenv'
require 'github_api'

class ReleaseNoteGeneratorCLI < Thor
  Dotenv.load

  desc "generate release_note", "generate release_note"

  method_option :org_name, type: :string, required: true
  method_option :repository, type: :string, required: true
  def gen
    github = Github.new(basic_auth: ENV['GITHUB_ACCESS_TOKEN'])

    params = {}
    params['per_page'] = 100
    params['state'] = 'closed'
    params['sort'] = 'updated'
    params['direction'] = 'desc'

    begin
      data = github.pulls.list(options[:org_name], options[:repository], params)
      pulls = data.to_a
    rescue Github::Error::Unauthorized => e
      say e.message, :red
      exit
    rescue Github::Error::NotFound => e
      say "Not found repository. please check org_name, repository: #{options[:org_name]}, #{options[:repository]}", :red
      say e.message, :red
      exit
    end


    lists = []
    pulls.each do |pr|
      break if pr['title'] =~ /リリースノート/
      list = {}
      list['number'] = pr['number']
      list['title'] = pr['title']
      list['url'] = pr['html_url']
      lists << list
    end

    lists.reverse!

    today = Date.today
    before = today - 6

    puts "## #{today.strftime('%Y/%m/%d')}"
    puts ""
    puts "### 対象日"
    puts "- #{before.strftime('%Y/%m/%d')} ~ #{today.strftime('%Y/%m/%d')}"
    puts ""
    puts "### 内容"
    puts ""
    lists.each do |list|
      puts "- #{list['title']}"
      puts "  - #{list['url']}"
    end
  end

  default_task :gen
end

ReleaseNoteGeneratorCLI.start(ARGV)

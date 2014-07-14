root = File.expand_path File.join(File.dirname(__FILE__), '..')

namespace :pages do

  cmd = lambda do |command|
    puts ">> executing: #{command}"
    system command or raise "#{command} failed"
  end

  desc 'Builds the site from Jekyll source'
  task :build do
    Dir.chdir(root) do
      cmd.call 'jekyll build'
    end
  end

  desc 'Pushes generated documentation to github pages: http://jdantonio.github.io'
  task :push => [:setup, :build] do

    message = Dir.chdir(root) do
      `git log -n 1 --oneline`.strip
    end
    puts "Generating commit: #{message}"

    Dir.chdir "#{root}/_site" do
      cmd.call "git add -A"
      cmd.call "git commit -m '#{message}'"
      cmd.call 'git push origin gh-pages'
    end

  end

  desc 'Setups second clone in ./_site dir for pushing to github'
  task :setup do

    unless File.exist? "#{root}/_site/.git"
      cmd.call "rm -rf #{root}/_site" if File.exist?("#{root}/_site")
      Dir.chdir "#{root}" do
        cmd.call 'git clone --single-branch --branch gh-pages git@github.com:jdantonio/jdantonio.github.io.git ./_site'
      end
    end
    Dir.chdir "#{root}/_site" do
      cmd.call 'git fetch origin'
      cmd.call 'git reset --hard origin/gh-pages'
    end
  end
end

task :site

task :index do
  Dir.chdir('docs') do
    sh("pandoc index.md -o index.html")
  end
end

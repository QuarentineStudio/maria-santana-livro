require 'yaml'
require 'json'
require 'byebug'

CONFIG = YAML.load_file("livro.yaml")

PASTA_RAIZ = CONFIG["pasta_raiz"]
ARQUIVOS = CONFIG["arquivos"]


task :site

desc 'Converte temp/texto.docx para markdown'
task :word2md do
  Dir.chdir('temp') do
    sh "pandoc texto.docx --extract-media=. -o texto.md --wrap=none"
  end
end

task :index do
  Dir.chdir('docs') do
    sh("pandoc index.md -o index.html")
  end
end

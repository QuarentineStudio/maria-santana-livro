require 'yaml'
require 'json'
require 'byebug'


ARQUIVOS.each do |f|
  file 'previa.pdf' => ["#{PASTA_RAIZ}/#{f}"]
end

file 'previa.pdf' do
  Dir.chdir(PASTA_RAIZ) do
    sh %Q(pandoc --pdf-engine=xelatex -V documentclass:scrbook #{ARQUIVOS.map{|f| "'#{f}'"}.join(" ")} -o previa.pdf)
  end
end








desc "Gera livro da prévia"
task :previa => 'previa.pdf'

require 'yaml'
require 'json'
require 'byebug'

CONFIG = YAML.load_file("livro.yaml")

PASTA_RAIZ = CONFIG["pasta_raiz"]


## Conta quantas palavras nos arquivos .md
## dentro do diretório
##
def conta_palavras_md(dir)
  palavras = 1
  #byebug
  Dir.glob(dir+"/*.md").each do |arq|
    words = `wc -w '#{arq}'`.strip!

    palavras += words.to_i if words != nil
  end
  palavras
end

def adiciona_ao_hash_pai(hash_pai, dir)
  #// se não tem subdiretórios
  tem_sub_dir = false
  Dir.each_child(dir) do |f|
    if Dir.exist? (File.join(dir,f))
      tem_sub_dir = true
    end
  end

  nome = File.basename(dir)
  if (tem_sub_dir)
    # Cria node pai
    node = {"name"=> nome, "children" => []}
    Dir.each_child(dir) do |f|
      subdir = File.join(dir,f)
      if Dir.exist? subdir
        adiciona_ao_hash_pai(node,subdir)
      end
    end
    hash_pai["children"] << node
  else
    # Adiciona filho
    children = hash_pai["children"]

    children << {"name" => nome, "value" => conta_palavras_md(dir)}
  end

end

namespace "grafico" do
  desc 'Cria gráfico das contribuições dos autores. Ver: https://observablehq.com/d/2cd90543a77c4d7f'
  task :autores do

    json_hash = {"name" => "Autores do livro", "children" => []}

    Dir.each_child(PASTA_RAIZ) do |filho|
      adiciona_ao_hash_pai(json_hash, File.join(PASTA_RAIZ,filho))
    end

    puts JSON.pretty_generate(json_hash)

    File.open('docs/autores.json', 'w') { |f| f << JSON.pretty_generate(json_hash) }


  end
end

desc "Gera arquivos json"
task :json => ["grafico:autores"]

require 'fileutils'

# Define o caminho das pastas
cg_all_path = '/home/guileb/tcc/CryptoSASTRunner/tccResults/desagroup_cc_cg/cg/cg_all'
cg_folders_root_path = '/home/guileb/tcc/CryptoSASTRunner/tccResults/desagroup_cc_cg/cg/cg_folders_root'

# Cria o diretório 'unknown_origin' se não existir
unknown_origin_dir = "#{cg_all_path}/unknown_origin"
FileUtils.mkdir_p(unknown_origin_dir) unless File.directory?(unknown_origin_dir)

# Itera sobre os arquivos em cg_all
Dir.glob("#{cg_all_path}/*.library_added.json").each do |library_file|
  # Obtém o nome do arquivo sem a extensão
  base_name = File.basename(library_file, '.library_added.json')

  # Inicializa uma flag para verificar se o arquivo foi encontrado
  file_found = false

  # Itera sobre as pastas em cg_folders_root
  Dir.glob("#{cg_folders_root_path}/*").each do |folder|
    # Verifica se o arquivo existe na pasta
    scout_file = "#{folder}/#{base_name}.scout.merged.json"
    next unless File.exist?(scout_file)

    # Obtém o nome da pasta e cria o caminho de destino
    destination_dir = "#{cg_all_path}/#{File.basename(folder)}"

    # Cria o diretório de destino se não existir
    FileUtils.mkdir_p(destination_dir) unless File.directory?(destination_dir)

    # Copia o arquivo para o diretório de destino
    FileUtils.cp(library_file, destination_dir)

    # Define a flag para true, indicando que o arquivo foi encontrado
    file_found = true
  end

  # Se o arquivo não foi encontrado, copia para 'unknown_origin'
  FileUtils.cp(library_file, unknown_origin_dir) unless file_found
end

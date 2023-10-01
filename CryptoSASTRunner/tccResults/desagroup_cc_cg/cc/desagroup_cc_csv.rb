require 'fileutils'

# Define o caminho das pastas
cc_all_path = '/home/guileb/tcc/CryptoSASTRunner/tccResults/desagroup_cc_cg/cc/cc_csvs/cc-report-with-external-and-possible-external'
cc_folders_root_path = '/home/guileb/tcc/CryptoSASTRunner/tccResults/desagroup_cc_cg/cc/cc_folders_root'

# Cria o diretório 'unknown_origin' se não existir
unknown_origin_dir = "#{cc_all_path}/unknown_origin"
FileUtils.mkdir_p(unknown_origin_dir) unless File.directory?(unknown_origin_dir)

# Itera sobre os arquivos em cc_all
Dir.glob("#{cc_all_path}/*.apk-report-extended.csv").each do |csv_file|
  # Obtém o nome do arquivo sem a extensão
  base_name = File.basename(csv_file, '.apk-report-extended.csv')

  # Inicializa uma flag para verificar se o arquivo foi encontrado
  file_found = false

  # Itera sobre as pastas em cc_folders_root
  Dir.glob("#{cc_folders_root_path}/*").each do |folder|
    # Verifica se o arquivo existe na pasta
    scout_file = "#{folder}/#{base_name}.scout.merged.json"
    next unless File.exist?(scout_file)

    # Obtém o nome da pasta e cria o caminho de destino
    destination_dir = "#{cc_all_path}/#{File.basename(folder)}"

    # Cria o diretório de destino se não existir
    FileUtils.mkdir_p(destination_dir) unless File.directory?(destination_dir)

    # Copia o arquivo para o diretório de destino
    FileUtils.cp(csv_file, destination_dir)

    # Define a flag para true, indicando que o arquivo foi encontrado
    file_found = true
  end

  # Se o arquivo não foi encontrado, copia para 'unknown_origin'
  FileUtils.cp(csv_file, unknown_origin_dir) unless file_found
end

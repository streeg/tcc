require 'csv'
require 'fileutils'
require 'byebug'

FOLDER = 'cg_csvs_system'

source_folder = "/home/guileb/tcc/CryptoSASTRunner/tccResults/desagroup_cc_cg/cg/cg_csvs/#{FOLDER}"
destination_folder = "#{source_folder}/#{FOLDER}_summary"
FileUtils.mkdir_p(destination_folder) unless Dir.exist?(destination_folder)

# Cria um hash para armazenar as informações de cada APK
apk_info = {}

quote_chars = %w[" | ~ ^ & *]

Dir.glob(File.join(source_folder, '*.csv')).each do |csv_file|
  apk_name = File.basename(csv_file.gsub('.apk-extended', ''), File.extname(csv_file))

  total_libraries = 0
  possible_external_libraries = 0
  definitely_external_libraries = 0

  begin
    CSV.foreach(csv_file, headers: true, col_sep: ',', quote_char: quote_chars.shift) do |row|
      total_libraries += 1
      possible_external_libraries += 1 if row['ExternalLibrary'] == 'false' && row['PossibleExternal'] == 'true'

      definitely_external_libraries += 1 if row['ExternalLibrary'] == 'true'
    end

    apk_info[apk_name] = {
      total: total_libraries,
      possible_external: possible_external_libraries,
      definitely_external: definitely_external_libraries
    }
  rescue CSV::MalformedCSVError
    quote_chars.empty? ? raise : retry
  rescue StandardError
    p "Erro no arquivo #{csv_file}"
  end
end

# Cria o arquivo CSV consolidado
summary_csv_path = "#{destination_folder}/summary.csv"
CSV.open(summary_csv_path, 'wb', col_sep: ';') do |csv|
  # Escreve o header
  csv << ['apk_name', 'libraries_with_vulnerability (total)', 'libraries_with_vulnerability (possible_external)',
          'libraries_with_vulnerability (definitely_external), native_libraries_with_vulnerability (total - possible_external - definitely_external)']

  # Escreve os dados para cada APK
  apk_info.each do |apk_name, info|
    csv << [apk_name, info[:total], info[:possible_external], info[:definitely_external],
            info[:total] - info[:possible_external] - info[:definitely_external]]
  end
end

require 'csv'
require 'json'
require 'byebug'

# Caminhos das pastas
merged_results_path = '/home/guileb/tcc/CryptoSASTRunner/tccResults/csvs-to-be-merged/all-merged-results-cg'
report_output_path = '/home/guileb/tcc/CryptoSASTRunner/tccResults/csvs-to-be-merged/cg-report-output'
report_new_output_path = '/home/guileb/tcc/CryptoSASTRunner/tccResults/csvs-to-be-merged/cg-report-with-external'

# Listar os arquivos nas pastas
merged_files = Dir.entries(merged_results_path).select { |f| File.file?("#{merged_results_path}/#{f}") }
report_files = Dir.entries(report_output_path).select { |f| File.file?("#{report_output_path}/#{f}") }

# Filtrar apenas os arquivos CSV
merged_files = merged_files.select { |f| f.end_with?('.json') }
report_files = report_files.select { |f| f.end_with?('.apk.csv') }

merged_files.each do |file_name|
  base_name = File.basename(file_name.gsub('.library_added', ''), '.json')
  # Verificar se o arquivo correspondente existe na pasta de relatórios
  next unless report_files.include?("#{base_name}.apk.csv")

  # Ler o CSV do relatório
  report_csv = CSV.read("#{report_output_path}/#{base_name}.apk.csv", headers: true)

  # Ler o JSON de resultados
  json_data = JSON.parse(File.read("#{merged_results_path}/#{file_name}"))

  # Processar os dados e criar novo CSV
  CSV.open("#{report_new_output_path}/#{base_name}.apk-extended.csv", 'w') do |csv|
    csv << report_csv.headers + ['ExternalLibrary']

    report_csv.each do |row|
      class_name = row['ClassName']
      method_name = row['MethodName']

      # Verificar se a classe existe no JSON e se é uma biblioteca externa
      byebug
      external_library = if json_data['Issues'].any? do |issue|
                              issue['_FullPath'].include?("#{class_name}.class") && issue['externalLibrary'] == true
                            end
                           true
                         else
                           false
                         end

      # Escrever no novo CSV
      csv << row.fields + [external_library]
    end
  end
end

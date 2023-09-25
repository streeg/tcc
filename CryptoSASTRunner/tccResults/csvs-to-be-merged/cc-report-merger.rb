require 'csv'
require 'json'
require 'byebug'

# Caminhos das pastas
merged_results_path = '/home/guileb/tcc/CryptoSASTRunner/tccResults/csvs-to-be-merged/all-merged-results-cc'
report_output_path = '/home/guileb/tcc/CryptoSASTRunner/tccResults/csvs-to-be-merged/cc-report-output'
report_new_output_path = '/home/guileb/tcc/CryptoSASTRunner/tccResults/csvs-to-be-merged/cc-report-with-external-and-possible-external'

# Listar os arquivos nas pastas
merged_files = Dir.entries(merged_results_path).select { |f| File.file?("#{merged_results_path}/#{f}") }
report_files = Dir.entries(report_output_path).select { |f| File.file?("#{report_output_path}/#{f}") }

# Filtrar apenas os arquivos CSV
merged_files = merged_files.select { |f| f.end_with?('.json') }
report_files = report_files.select { |f| f.end_with?('.apk-report.csv') }

merged_files.each do |file_name|
  base_name = File.basename(file_name.gsub('.library_added', ''), '.json')
  next unless report_files.include?("#{base_name}.apk-report.csv")

  quote_chars = %w[" | ~ ^ & *]
  begin
    report_csv = CSV.read("#{report_output_path}/#{base_name}.apk-report.csv", headers: true,
                                                                               quote_char: quote_chars.shift,
                                                                               col_sep: ';') # Definindo o separador como ;
  rescue CSV::MalformedCSVError
    quote_chars.empty? ? raise : retry
  end

  json_data = JSON.parse(File.read("#{merged_results_path}/#{file_name}"))

  CSV.open("#{report_new_output_path}/#{base_name}.apk-report-extended.csv", 'w', col_sep: ';', quote_char: '',
                                                                                  force_quotes: false) do |csv|
    csv << report_csv.headers + ['ExternalLibrary'] + ['PossibleExternal']

    report_csv.each do |row|
      class_name = row['Class']
      method_name = row['Method']
      error_type = row['ErrorType']
      violated_rule = row['ViolatedRule']
      object = row['Object']
      statement = row['Statement']
      external_library = json_data['runs'][0]['results'].any? do |result|
        result['locations'][0]['physicalLocation']['fileLocation']['uri']&.include?("#{class_name}.") && result['locations'][0]['physicalLocation']['fileLocation']['externalLibrary'].eql?(true)
      end
      possible_external = json_data['runs'][0]['results'].any? do |result|
        result['locations'][0]['physicalLocation']['fileLocation']['uri']&.include?("#{class_name}.") && result['locations'][0]['physicalLocation']['fileLocation']['PossibleExternalLibrary'].eql?(true)
      end

      # Evitando quebras de formatação
      object = object.gsub(';', '/') if object

      csv << [error_type, class_name, method_name, violated_rule, object, statement,
              external_library ? 'true' : 'false', possible_external ? 'true' : 'false']
    end
  end
end

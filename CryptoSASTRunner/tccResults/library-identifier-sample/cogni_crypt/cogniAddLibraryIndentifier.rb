require 'json'
require 'byebug'

# @Note: Take merged results and add library identifier when exists

###### Constants ######

COGNICRYPT_MERGED_PATH = '/home/guileb/tcc/CryptoSASTRunner/tccResults/library-identifier-sample/cogni_crypt/*.scout.merged.json'.freeze # change_path_as_needed
SCOUT_WITH_LIBRARY_INDENTIFIER = '/home/guileb/tcc/CryptoSASTRunner/tccResults/library-identifier-sample/cogni_crypt/'.freeze
LIBRARY_ADDED_PATH = '/home/guileb/tcc/CryptoSASTRunner/tccResults/library-identifier-sample/cogni_crypt/'.freeze
###### Main ######
lib_files = Dir[COGNICRYPT_MERGED_PATH]
lib_files.each do |file|
  lib_file = File.open(file, 'r')
  lib_file_data = JSON.load(lib_file)
  lib_file_name = File.basename(file)
  scout_file = File.open(SCOUT_WITH_LIBRARY_INDENTIFIER + lib_file_name.gsub('scout.merged.json', 'log.json'), 'r')
  scout_file_data = JSON.load(scout_file)

  results = []
  lib_file_data['runs'][0]['results'].each do |x|
    results << x['locations'][0]['physicalLocation']['fileLocation']['uri']
  end
  index = 0
  results.each { |x| x.gsub!('/', '.') }
  results.each do |result|
    scout_file_data_items = scout_file_data[0]
    scout_file_data_items.each do |scout_file_data_item|
      result = result.gsub(/^([a-z].*).apk./, '')
      splited_result = result.gsub('.', ' ').split
      begin
        splited_lib_data = scout_file_data_item['LibraryIndentified'].gsub('.', ' ').split
        if splited_result.any? { |splited| splited_lib_data.include?(splited) }
          lib_file_data['runs'][0]['results'][index]['locations'][0]['physicalLocation']['fileLocation']['PossibleExternalLibrary'] =
            true
        end
      rescue StandardError => e
      end
    end
    index += 1
  end
  path_lib_file_name = lib_file_name.gsub('.scout.merged.json', '.library_added.json')
  merged_file = File.new(path_lib_file_name, 'w')
  merged_file.write(JSON.pretty_generate(lib_file_data))
  merged_file.close
end

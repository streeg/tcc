require 'json'
require 'byebug'

###### Methods ######

def is_scout?
  ARGV[0].eql?('scout')
end

def is_radar?
  ARGV[0].eql?('radar')
end

def extract_and_format_name_sarif(file)
  if is_scout?
    file = file.gsub('libscout-result/json/', 'cryptoguard-sarif/')
    file.gsub('.log', '.apk-sarif')
  else
    file = file.gsub('libradar-result/', 'cryptoguard-sarif/')
    file.gsub('.json', '.apk-sarif.json')
  end
end

def format_crypto_lib_merged_name(file)
  if is_scout?
    file = file.gsub('libscout-result/json/', 'crypto-lib-merged-result/libscout/')
    file.gsub('.log', '.scout.merged')
  else
    file = file.gsub('libradar-result/', 'crypto-lib-merged-result/libradar/')
    file.gsub('.json', '.radar.merged.json')
  end
end

###### Main ######

p 'This script merge libscout or libradar result and cryptoguard result into new file.'

if ARGV.length != 1
  p 'Usage: ruby crypto_lib_merger.rb scout / radar'
  exit
end

if is_scout?
  p 'Merge libscout result selected'
  lib_files = Dir['libscout-result/json/*.log.json']
elsif is_radar?
  p 'Merge libradar result selected'
  lib_files = Dir['libradar-result/*.json']
else
  p 'Usage: ruby crypto_lib_merger.rb scout or radar'
  exit
end

files_count = lib_files.size
p "There is #{files_count} files to merge"
counter = 0
lib_files.each do |lib_file_name|
  counter += 1

  # Open lib file
  lib_file = File.open(lib_file_name, 'r')
  lib_file_data = JSON.load(lib_file)
  # p lib_file_data.each { |x| p x['Package'] }

  # Open crypto file
  crypto_file = File.open(extract_and_format_name_sarif(lib_file_name), 'r')
  crypto_file_data = JSON.load(crypto_file)

  # Save matches from crypto file to results array
  results = []
  crypto_file_data['runs'][0]['results'].each do |x|
    results << x['locations'][0]['physicalLocation']['fileLocation']['uri']
  end

  # Check if results array matches any of the lib file data. If it does, add it to the new array.
  index = 0
  results.each { |x| x.gsub!('/', '.') }
  results.each do |result|
    lib_file_data.each do |lib_file_data_item|
      next if lib_file_data_item['Package'].nil?

      splited_result = result.gsub('.', ' ').split
      splited_lib_data = lib_file_data_item['Package'].gsub('.', ' ').split
      next unless splited_result.any? { |splited| splited_lib_data.include?(splited) }

      crypto_file_data['runs'][0]['results'][index]['locations'][0]['physicalLocation']['fileLocation']['externalLibrary'] =
        true
    end
    index += 1
  end

  merged_file = File.new(format_crypto_lib_merged_name(lib_file_name), 'w')
  merged_file.write(JSON.pretty_generate(crypto_file_data))
  merged_file.close
  p "Merged #{counter} of #{files_count} crypto+lib#{ARGV[0]} files"
  lib_file.close
  crypto_file.close
end

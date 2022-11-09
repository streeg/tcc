require 'json'
require 'byebug'

###### Constants ######

PILOT_PATH = '/home/guileb/tcc/CryptoSASTRunner/tccResults/crypto-lib-merged-result/libscout/piloto-1-merged-results'

###### Main ######
p 'This script count number of external libraries and number of native and print in a csv'
p 'It should report apk name, number of external libraries, number of native libraries'

pilot_path = Dir[PILOT_PATH + '/*.json']
files_count = pilot_path.size
p "There is #{files_count} files in this directory"
counter = 0
failed_files = []
successed_files = []
csv_file = File.new('pilot_external_counter_report.csv', 'w')
csv_file.write("apk_name,external_libs_count,native_libs_count\n")
pilot_path.each do |lib_file_name|
  counter += 1
  external_libs_count = 0

  # Open lib file, parse it and count number of external and native libs
  lib_file = File.open(lib_file_name, 'r')
  apk_name = File.basename(lib_file_name)
  lib_file_data = JSON.load(lib_file)
  libs_count = lib_file_data['runs'][0]['results'].count
  lib_file_data['runs'][0]['results'].each do |lib|
    external_libs_count += 1 if lib['locations'][0]['physicalLocation']['fileLocation'].include?('externalLibrary')
  end
  native_libs_count = libs_count - external_libs_count
  csv_file.write("#{apk_name},#{external_libs_count},#{native_libs_count}\n")
  p "Merged #{counter} of #{files_count} files"
  lib_file.close

  successed_files << lib_file_name
rescue StandardError => e
  p e
  failed_files << lib_file_name
end
csv_file.close

p "There was #{failed_files.length} errors out of #{files_count} files."
p "Failed files: #{failed_files}!"
p "Success files: #{successed_files}."

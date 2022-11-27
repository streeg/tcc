require 'json'
require 'byebug'

###### Constants ######

PILOT_PATH = '/home/guileb/tcc/CryptoSASTRunner/tccResults/crypto-lib-merged-result/libscout-cognicrypt/piloto-1-merged-results'
PILOT_NAME_PATH = 'cognicrypt_pilot_external_counter_report.csv'
CONNECTIVITY_PATH = '/home/guileb/tcc/CryptoSASTRunner/tccResults/crypto-lib-merged-result/libscout-cognicrypt/connectivity-merged-results'
CONNECTIVITY_NAME_PATH = 'cognicrypt_connectivity_external_counter_report.csv'
FINANCES_PATH = '/home/guileb/tcc/CryptoSASTRunner/tccResults/crypto-lib-merged-result/libscout-cognicrypt/finances-merged-results'
FINANCES_NAME_PATH = 'cognicrypt_finances_external_counter_report.csv'
SECURITY_PATH = '/home/guileb/tcc/CryptoSASTRunner/tccResults/crypto-lib-merged-result/libscout-cognicrypt/security-merged-results'
SECURITY_NAME_PATH = 'cognicrypt_security_external_counter_report.csv'
SMS_PATH = '/home/guileb/tcc/CryptoSASTRunner/tccResults/crypto-lib-merged-result/libscout-cognicrypt/system-merged-results'
SMS_NAME_PATH = 'cognicrypt_system_external_counter_report.csv'
SYSTEM_PATH = '/home/guileb/tcc/CryptoSASTRunner/tccResults/crypto-lib-merged-result/libscout-cognicrypt/system-merged-results'
SYSTEM_NAME_PATH = 'cognicrypt_system_external_counter_report.csv'

LOADED_PATH = SYSTEM_PATH
LOADED_NAME_PATH = SYSTEM_NAME_PATH

###### Main ######
p 'This script count number of external libraries and number of native and print in a csv'
p 'It should report apk name, number of external libraries, number of native libraries'

loaded_path = Dir[LOADED_PATH + '/*.json']
files_count = loaded_path.size
p "There is #{files_count} files in this directory"
counter = 0
failed_files = []
successed_files = []
csv_file = File.new(LOADED_NAME_PATH, 'w')
csv_file.write("apk_name,external_libs_count,native_libs_count\n")
loaded_path.each do |lib_file_name|
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

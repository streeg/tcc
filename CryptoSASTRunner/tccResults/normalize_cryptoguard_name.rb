require 'json'
require 'byebug'

###### Constants ######

CRYPTOGUARD_PATH = '/home/guileb/tcc/CryptoSASTRunner/tccResults/cryptoguard/piloto-2/'.freeze # remove piloto-2
CRYPTOGUARD_PILOTO_PATH = '/home/guileb/tcc/CryptoSASTRunner/tccResults/cryptoguard/piloto-2/*.json'.freeze # remove piloto-2

###### Main ######

lib_files = Dir[CRYPTOGUARD_PILOTO_PATH]
lib_files.each do |file|
  # Open lib file
  lib_file = File.open(file, 'r')
  lib_file_data = JSON.load(lib_file)
  lib_file_name = lib_file_data['Target']['FullPath']
  File.rename(file, CRYPTOGUARD_PATH + lib_file_name.gsub('.apk/', '.json'))
  lib_file.close
end

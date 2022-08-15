import os
import glob
import subprocess
import time

user = 'guileb'
customPath = '/tcc/CryptoSASTRunner/'
apksPath = '/home/' + user + customPath + '/cryptoRunner/projects/apks/'
libScoutPath = '/home/' + user + customPath + '/libScout/'
libScoutlLogsPath = '/home/' + user + customPath + '/libScout/logs/'
libScoutJsonLogsPath = '/home/' + user + customPath + '/libScout/jsonlogs/'
tccResults = '/home/' + user + customPath + '/tccResults/'
libScoutResultsJson = 'libscout-result/json'
cryptoSASTRunnerPath = '/home/' + user + customPath
sarifOutput = cryptoSASTRunnerPath + 'cryptoRunner/results/cryptoSarifOutput'
cryptoguardSarifResults = 'cryptoguard-sarif'
extension = 'apk'

start_time = time.time()

os.chdir(sarifOutput)
crypto_results = [i for i in glob.glob('*.{}'.format('json'))]
for crypto_file in crypto_results:
    subprocess.call(['cp', crypto_file, tccResults + cryptoguardSarifResults])

os.chdir(apksPath)
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
os.chdir(libScoutPath)


for file in all_filenames:
    subprocess.call(['java', '-jar', 'build/libs/LibScout.jar', '-o',
                    'match', '-a', 'build/libs/Android.jar', apksPath + file, '-d'])
    print("Analysis finished for project: " + file)

os.chdir(libScoutlLogsPath)
subprocess.call(['ruby', 'libscout-log-to-json.rb'])


os.chdir(libScoutJsonLogsPath)
json_filenames = [i for i in glob.glob('*.{}'.format('json'))]
for json_file in json_filenames:
    subprocess.call(['cp', json_file, tccResults + libScoutResultsJson])


os.chdir(tccResults)
subprocess.call(['ruby', 'crypto_lib_merger.rb', 'scout'])

print("Analysis finished for: ")
print(all_filenames)
print("--- %s seconds ---" % (time.time() - start_time))

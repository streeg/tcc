# tcc

# Run libscout 
inside libscout folder (must be on root)
java -jar build/libs/LibScout.jar -o match -a Android.jar ../test-apks/de.varengold.activeTAN_34-debug.apk -d

note: -a,--android-sdk | -d,--log-dir directory to store the logfile(s), to "./logs" | -o,--opmode mode of operation, one of profile|match|lib_api_analysis|updatability]



# Run libradar 
inside libradar/ (python2)

inside tool/ 

you must set the path of redis.conf around line 246 to your libradar path:  "/home/guileb/tcc/LibRadar/"

make sure redis is not running with: /etc/init.d/redis-server stop

run command: redis-server redis.conf

inside libradar/

python libradar.py ../../LibRadar/test-apks/esv-v0.8.1-beta1.apk > ../../../test-apks/libradar-result/esv.json


# tcc

# Run libscout 
inside libscout-master folder
java -jar build/libs/LibScout-master.jar -o match -a ../../Android/Sdk/platforms/android-33/android.jar ../test-apks/de.varengold.activeTAN_34-debug.apk -d

note: -a,--android-sdk | -d,--log-dir directory to store the logfile(s), to "./logs" | -o,--opmode mode of operation, one of profile|match|lib_api_analysis|updatability]



# Run libradar 
inside libradar-master/libradar-2.2.1 (python2)
inside tool/ 
redis-server redis.conf
inside libradar/
python libradar.py ../../LibRadar/test-apks/esv-v0.8.1-beta1.apk > ../../../test-apks/libradar-result/esv.json


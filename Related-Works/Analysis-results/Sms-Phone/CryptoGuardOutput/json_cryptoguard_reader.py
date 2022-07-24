import json
import os
import fnmatch


writer = open("sms-phone_cryptoguard.csv", "a")
files = fnmatch.filter(os.listdir(os.getcwd()), '*.json')
writer.write("apk,issues\n")

for file in files:
  f = open(file)
  data = json.load(f)
  writer.write(data["Target"]["FullPath"][:-1])
  writer.write(",")
  writer.write(str(len(data["Issues"])))
  writer.write("\n")
  f.close()

writer.close()
p 'All files in the logs directory will be converted to JSON and saved to ../jsonlogs'
log_files = Dir['*.log']
files_count = log_files.size
p "There is #{files_count} log files to convert"
counter = 0
log_files.each do |log_file|
  counter += 1
  log_to_json = File.open("../security_sample_json_with_libraries/#{log_file}.json", 'w')
  log_to_json.write("[\n")
  log = File.open(log_file, 'r')
  log_to_json.write("[\n")
  log.each_line do |line|
    if line.include?('LibraryIdentifier') && line.split.include?('package')
      log_to_json.write("  {\n    \"LibraryIndentified\": \"#{line.split[line.split.index('package') + 1]}\",\n")
      log_to_json.write("    \"SubLibrary\": \"#{line.split[line.split.index('package') + 2]}\"\n  },\n")
    end
    log_to_json.write("{}],\n[") if line.include?('Full library matches:')
    next unless line.include?('ProfileMatch')

    if line.split.include?('name:')
      log_to_json.write("  {\n    \"Library\": \"#{line.split[line.split.index('name:') + 1]}\",\n")
    end
    if line.split.include?('category:')
      log_to_json.write("    \"Category\": \"#{line.split[line.split.index('category:') + 1]}\",\n")
    end
    if line.split.include?('version:')
      log_to_json.write("    \"Version\": \"#{line.split[line.split.index('version:') + 1]}\",\n")
    end
    if line.split.include?('package:')
      log_to_json.write("    \"Package\": #{line.split[line.split.index('package:') + 1]}\n  },\n")
    end
  end
  log.close
  log_to_json.write('{}]]')
  log_to_json.close
  p "Converted #{log_file} to json"
  p "Converted #{counter} of #{files_count} log files"
  p 'Starting next file'
end
p 'All files converted to json'

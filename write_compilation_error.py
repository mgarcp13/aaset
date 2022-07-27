#! /usr/bin/python3

import sys
import json

exec_dir=sys.argv[1]
report_output_dir=exec_dir+"/output/report/"
compilation_errors_file=report_output_dir+"compilation_errors.err"

# List including the whole report
errors_list=list()

for error in open(compilation_errors_file,'r').readlines():
    errors_list.append({"error":error.strip(),"type":"compilation"})
open(report_output_dir+"report.json",'w').write(json.JSONEncoder().encode({"compilation_errors":errors_list}))

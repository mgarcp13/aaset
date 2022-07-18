#! /usr/bin/python3

import re
import sys
import json
from pathlib import Path

exec_dir=sys.argv[1]
klee_output_dir=exec_dir+"/output/klee/"
report_output_dir=exec_dir+"/output/report/"

# List including the whole report
report_list=list()

path=Path(klee_output_dir)
for case_file in path.glob("test[0-9]*.txt"):
    report=open(case_file,'r').read()
    # Regular expression to get the number of objects (num objects: X)
    num_objects_match=re.match(r'(?:num\ objects[:])(?:\s)*([0-9]*)',report)
    if num_objects_match:
        # List which include the list with all objects information plus the case error information
        case_list=list()
        # List which includes the list with info of all objects
        objects_list=list()
        num_objects=int(num_objects_match.group(1))
        for object_num in range(num_objects):
            # Regular expression to get a list with all info for the current object (object X: key: value)
            object_info_match=re.findall(r'(?:object)(?:\s)*'+str(object_num)+'(?:[:])(?:\s)*(.*)',report)
            if object_info_match:
                object_info_dict={}
                for object_info in object_info_match:
                    info=object_info.split(":")
                    object_info_dict[info[0]]=info[1].strip()
                objects_list.append(object_info_dict)
        # Get errors during concrete exeution
        case_list.append({"objects":objects_list})
        error_match=re.search(r'(?:Error[:])(?:\s)*(.*)',report)
        if error_match:
            error_info={}
            error_info["error"]=error_match.group(1)
            case_list.append(error_info)
        # Get errors during symbolic execution
        error_match=re.search(r'(?:Klee\ Error[:])(?:\s)*(.*)',report)
        if error_match:
            error_info={}
            error_info["klee error"]=error_match.group(1)
            case_list.append(error_info)
        report_list.append(case_list)
if report_list:
    open(report_output_dir+"report.json",'w').write(json.JSONEncoder().encode({"cases":report_list}))
else:
    open(report_output_dir+"report.json",'w').write(json.JSONEncoder().encode({"msg":"no errors found"}))

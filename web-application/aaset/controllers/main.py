# -*- coding: utf-8 -*-
def load():
    response.view = 'main/load.html'
    return dict()

def report():
    import json
    import subprocess
    import os
    from random import seed
    from random import randint
    
    response.view = 'main/report.html'
    
    seed()
    exec_dir="exec."+str(randint(0,1000))
    
    file = request.vars.source.file
    filename = request.vars.source.filename
    output_file=open("/tmp/"+filename, "wb").write(file.read())
    
    old_dir=os.getcwd()
    os.chdir('../')
    
    subprocess.run(["./automatic_klee_execution.sh",request.vars.module,"/tmp/"+filename,exec_dir])
    
    report=open(exec_dir+"/output/report/report.json","r").read()
    subprocess.run(["rm","-rf",exec_dir])
    
    os.chdir(old_dir)
        
    return dict(reporte=json.JSONDecoder().decode(report))

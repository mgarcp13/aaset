from flask import Flask, request, jsonify
import json
import subprocess
from random import seed
from random import randint

app = Flask(__name__)

@app.post("/report")
def report():
    file=request.files.get("file")
    filename=file.filename
    file.save("/tmp/"+filename)

    module=request.form.get("module")

    seed()
    exec_dir="exec."+str(randint(0,1000))
    
    subprocess.run(["./automatic_klee_execution.sh",module,"/tmp/"+filename,exec_dir])
    
    report=open(exec_dir+"/output/report/report.json","r").read()
    subprocess.run(["rm","-rf",exec_dir])
    
    return dict(json.JSONDecoder().decode(report)), 200

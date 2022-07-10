#! /usr/bin/python3

import re
import sys

# Input and Output file location directories
exec_dir=sys.argv[2]
src_dir=exec_dir+"/src"
src_main_dir=src_dir+"/main/"
src_include_dir=src_dir+"/include/"
output_dir=exec_dir+"/tools/converter/src/"

ident="  "
main=""
package=""
output_filename="p_converter"
ada_body_extension=".adb"
ada_spec_extension=".ads"

# This list include the name of all procedures
procedures=list()
# This list include a list of all params for each procedure
params=list(list())
# This list include all params for a single procedure.
# This list is append to params: params=[[function_params1],[function_params2],...,[function_paramsN]]
function_params=list()
# This set include all params in a single list to check if a param already exists before append it
all_params=set()
# This set include packages to be imported
imports=set()
# This dictonary include the type name among their convert function name
convert_functions={}


# Get the package where an object or procedure is located to import it
def get_imports (item):
    item_definition=item.split(".")
    item_definition_length=len(item_definition)
    if item_definition_length>1:
        import_package=""
        for i in range(len(item_definition[:item_definition_length-1])):
            import_package+=item_definition[i]
            if i<item_definition_length-2:
                import_package+="."
        imports.add(import_package)

# In procedures params could be in, our or in out mode. Remove mode from type
def remove_param_mode (param_type):
    type_declaration=param_type.split(' ')
    param_type=type_declaration[len(type_declaration)-1]
    return param_type

# Check if already exists a param with the same name and different type. If so renames new
# param adding the suffix _1
# Same params (name are type are the same) are only write once
def check_param (param_name, param_type):
    for param in all_params:
        param_declaration=param.split(":")
        name=param_declaration[0].strip()
        ptype=param_declaration[1].strip()
        # If param name already exists but type is diferent renames new param
        if name==param_name and ptype!=param_type:
            param_name+="_1"
            break
    all_params.add(param_name+" : "+param_type)
    return param_name
        
# Add a new param to the list
def add_param (param_name, param_type):
    param_type=remove_param_mode(param_type)
    param_name=check_param(param_name, param_type)
    param_declaration=(param_name+" : "+param_type+";")
    function_params.append(param_declaration)
    get_imports(param_type)


#########################################
#### PRINT FUNCTIONS
#########################################

# Return a string with all imports needed
def print_imports():
    import_declarations=""
    for imp in imports:
        import_declarations+="with "+imp+"; use "+imp+";\n"
    import_declarations+="with ADA.COMMAND_LINE;\n"
    import_declarations+="with ADA.TEXT_IO;\n"
    import_declarations+="with Q_CONVERTER; use Q_CONVERTER;\n"
    package_name=package.upper().replace('-','.')
    subpackages_list=package_name.split('.')
    for i in range(len(subpackages_list)):
        import_declarations+="with "+".".join(subpackages_list[0:i+1])+"; use "+".".join(subpackages_list[0:i+1])+";\n"
    import_declarations+="\n\n"
    return import_declarations

# Return a string with all params used in procedures and create and object with the param name
def print_params():
    params=""
    for param in all_params:
        name=param.split(":")[0].strip()
        params+=ident+param+";\n\n"
    return params

# Return the call to all procedures declared in file with their params made symbolic
def call_procedures():
    calls=""
    for i in range(len(procedures)):
        calls+=ident+procedures[i]+" ("
        for j in range(len(params[i])):
            calls+=params[i][j].split(":")[0].strip()
            if j<len(params[i])-1:
                calls+=", "
        calls+=");\n\n"
    return calls

# Return a string declaration all convert function and create a dictonary with the type name and
# the convert function name for that type
def get_convert_functions():
    convert_functions_declaration=""
    for param in all_params:
        type_name=param.split(":")[1].strip()
        convert_functions[type_name]="F_"+type_name+"_CONVERTER"
        convert_functions_declaration+=ident+"function "+convert_functions[type_name]+" is new Q_CONVERTER.F_GET_VALUE ("+type_name+");\n\n"
    return convert_functions_declaration

def get_value_functions():
    get_value_functions_body=""
    for param_index,param in enumerate(all_params):
        get_value_functions_body+=(ident)+"Q_INTEGER_IO.GET\n"
        get_value_functions_body+=(ident*2)+"(FROM => ADA.COMMAND_LINE.ARGUMENT ("+str(param_index+1)+"),\n"
        get_value_functions_body+=(ident*2)+" ITEM => V_HEX,\n"
        get_value_functions_body+=(ident*2)+" LAST => V_LAST);\n\n"
        param_split=param.split(":")
        get_value_functions_body+=(ident)+param_split[0].strip()+" := "+convert_functions[param_split[1].strip()]+" (V_HEX);\n\n"
    return get_value_functions_body



#########################################

# This python script takes a package name (without extension) and creates a new main procedure which takes all
# the procedures declared in package spec with all the params of all procedures. Take values from klee executions,
# convert then into the variables preoviously declared and call all the procedures using those values

package=sys.argv[1]
input_file=open(src_include_dir+package+ada_spec_extension,'r')
output_file=open(output_dir+output_filename+ada_body_extension,'w')
input_string=input_file.read()

all_procedures_declaration=re.findall(r'(?:(?:procedure)[ ]+)([0-9A-Z_]*)(?:\s)*(?:[(])(.*?)(?:[)])(?:.*?[;])',input_string,re.DOTALL)

if all_procedures_declaration:
    for procedure_declaration in all_procedures_declaration:
        procedure_name=procedure_declaration[0].upper()
        procedures.append(procedure_name)
        get_imports(procedure_name)
        procedure_params=procedure_declaration[1].split(';')
        for i in procedure_params:
            function_param_operands=i.split(':')
            add_param(function_param_operands[0].strip().upper(),function_param_operands[1].strip().upper())
        params.append(list(function_params))
        del function_params[:]
    
    main+=print_imports()
    main+="procedure "+output_filename.upper()+" is\n\n"
    main+=print_params()
    main+=get_convert_functions()
	#main+=ident+"package Q_INTEGER_IO is new ADA.TEXT_IO.INTEGER_IO (LONG_LONG_INTEGER);\n\n"
    main+=ident+"package Q_INTEGER_IO is new ADA.TEXT_IO.INTEGER_IO (LONG_LONG_INTEGER);\n\n"
    main+=ident+"V_HEX : LONG_LONG_INTEGER;\n\n"
    main+=ident+"V_LAST : POSITIVE;\n\n"
    main+="begin\n\n"
    main+=get_value_functions()
    main+=call_procedures()
    main+="end "+output_filename.upper()+";"
output_file.write(main)
output_file.close()
print ("File "+output_filename+ada_body_extension+" written")

#########################################


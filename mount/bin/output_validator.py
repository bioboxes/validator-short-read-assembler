__author__ = 'pbelmann'

import argparse
import sys
import yaml
import validictory as js
import os.path

def validate_schema(input_yaml_path, schema_file):
    yaml_data_in = None
    try:
       yaml_data_in = yaml.load(file(input_yaml_path, 'r'))
    except yaml.YAMLError, exc:
       sys.stderr.write("Error parsing: \"/bbx/output.yaml\".\n" +
                                         "This file is not valid YAML.")
       return 1
    json_data_schema = yaml.load(open(schema_file))
    try:
        js.validate(yaml_data_in, json_data_schema)
    except ValueError as error:
        sys.stderr.write(error.message)
        return 1
    return 0

def existsFasta(input_yaml_path, outputDir):
    yaml_data_in = yaml.load(file(input_yaml_path, 'r'))
    for argument in yaml_data_in.arguments:
        fastaPath = outputDir + argument["fasta"]["value"]
        if(not os.path.isfile(fastaPath)):
            sys.stderr.write(fastaPath + " does not exists")
            return 1
    return 0

if __name__ == "__main__":
    #Parse arguments
    parser = argparse.ArgumentParser(description='Parses input yaml')
    parser.add_argument('-i', '--input_yaml', dest='i', nargs=1,
                        help='YAML input file')
    parser.add_argument('-s', '--schema_yaml', dest='s', nargs=1,
                        help='YAML schema file')
    parser.add_argument('-o', '--output_path', dest='o', nargs=1,
                        help='output path')
    args = parser.parse_args()

    #get input files
    input_yaml_path = ""
    schema_file = ""
    output_path = ""
    if hasattr(args, 'i'):
        input_yaml_path = args.i[0]
    if hasattr(args, 's'):
        schema_file = args.s[0]
    if hasattr(args, 'o'):
        output_path = args.o[0]

    sys.exit(validate_schema(input_yaml_path,schema_file) and existsFasta(input_yaml_path,output_path))
#!/usr/bin/env python
from jinja2 import Template
import os, argparse


def read_file(file_loc):
    auth_conf = open(file_loc,"r")
    txt = "".join(auth_conf.readlines())
    auth_conf.close()
    return txt

def generate_config(tmpl_file,conf_file):
    template = Template(read_file(tmpl_file))
    envargs = {envar[0]:envar[1] for envar in os.environ.items() if envar[0].startswith("ZEPPELIN_")}
    conf_content = template.render(**envargs)
    conf = open(conf_file,"w")
    conf.write(conf_content)
    conf.close()
    return conf

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Config Generator")
    parser.add_argument("--template",action="store", type=str, help="Full location of *.template file. Must be jinja2 template.")
    parser.add_argument("--conf",action="store", type=str, help="Full location of the config file to generate.")
    args = parser.parse_args()

    print("Generating config %s" % (args.conf))
    generate_config(args.template,args.conf)

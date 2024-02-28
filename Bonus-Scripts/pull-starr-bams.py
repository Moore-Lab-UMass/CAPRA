import sys, json, urllib.request, urllib.parse, urllib.error
import base64
import os.path
import os
from requests.auth import HTTPBasicAuth
import requests

def Process_Token():
    credentials=open("/home/moorej3/.encode.txt")
    credArray=next(credentials).rstrip().split("\t")
    return credArray[0], credArray[1]

def Download_File(name, extension, usrname, psswd, outputDir):
    if not os.path.exists(outputDir+"/"+name+"."+extension):
        print("downloading "+name+" ...")
        url="https://www.encodeproject.org/files/"+name+"/@@download/"+name+"."+extension
        r = requests.get(url, auth=HTTPBasicAuth(usrname, psswd))
        outputFile=open(outputDir+"/"+name+"."+extension, "wb")
        outputFile.write(r.content)
        outputFile.close()

def Retrieve_Biosample_Summary(dataset, creds, usrname, psswd):
    try:
        dataDir="/data/projects/encode/json/exps/"+dataset
        json_data=open(dataDir+".json").read()
        data = json.loads(json_data)
    except:
        url = "https://www.encodeproject.org/"+dataset+"/?format=json"
        request = urllib.request.Request(url)
        request.add_header("Authorization", "Basic %s" % creds)
        response = urllib.request.urlopen(request)
        data = json.loads(response.read())

    name = data["biosample_summary"]
    typ = data["biosample_ontology"]["classification"]
    lab = data["lab"]["title"]
    status = data["status"]

    rnaBams = []
    for f in data["files"]:
        if f["file_type"] == "bam":
            fileAccession = f["accession"]
            rnaBams.append(fileAccession)
            if not os.path.exists("/data/projects/encode/json/exps/"+dataset+"/"+fileAccession+".bam"):
                outputDir="/home/moorej3/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/Data/"+dataset
                if not os.path.exists(outputDir):
                    os.mkdir(outputDir)
                Download_File(fileAccession, "bam", usrname, psswd, outputDir)

    dnaBams = []
    location = "no-files"
    for entry in data["possible_controls"]:
        location = "NA"
        accession = entry["accession"]
        try:
            dataDir="/data/projects/encode/json/exps/"+accession
            json_data=open(dataDir+".json").read()
            newData = json.loads(json_data)
        except:
            url = "https://www.encodeproject.org/"+accession+"/?format=json"
            request = urllib.request.Request(url)
            request.add_header("Authorization", "Basic %s" % creds)
            response = urllib.request.urlopen(request)
            newData = json.loads(response.read())

        for f in newData["files"]:
            if f["file_type"] == "bam":
                fileAccession = f["accession"]
                dnaBams.append(fileAccession)
                if not os.path.exists("/data/projects/encode/json/exps/"+accession+"/"+fileAccession+".bam"):
                    outputDir="/home/moorej3/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/Data/"+dataset
                    if not os.path.exists(outputDir):
                        os.mkdir(outputDir)
                    Download_File(fileAccession, "bam", usrname, psswd, outputDir)
    try:
        description = data["description"]
    except:
        description = "NA"

    return name, typ, lab, rnaBams, dnaBams, description, location, status

usrname, psswd = Process_Token()
base64string = base64.b64encode(bytes('%s:%s' % (usrname,psswd),'ascii'))
creds = base64string.decode('utf-8')

species=sys.argv[1]
url = "https://www.encodeproject.org/search/?type=FunctionalCharacterizationExperiment"+ \
    "&assay_title=STARR-seq&status=released&replicates.library.biosample.donor."+ \
    "organism.scientific_name="+species+"&format=json&limit=all&status=submitted&status=in+progress"

request = urllib.request.Request(url)
request.add_header("Authorization", "Basic %s" % creds)
response = urllib.request.urlopen(request)
data = json.loads(response.read())

for entry in data["@graph"]:
    name, typ, lab, rnaBams, dnaBams, description, location, status = \
        Retrieve_Biosample_Summary(entry["accession"], creds, usrname, psswd)
    #if guideFiles == []:
    #    print(entry["accession"]+"\t"+name+"\t"+typ+"\t"+lab \
    #        +"\t"+description+"\t"+location+"\t"+"NONE"+"\t"+status+"\t"+location)
    #for guideFile in guideFiles:
    #    print(entry["accession"]+"\t"+name+"\t"+typ+"\t"+lab \
    #        +"\t"+description+"\t"+location+"\t"+guideFile+"\t"+status+"\t"+location)
    print(entry["accession"]+"\t"+name+"\t"+typ+"\t"+lab\
             +"\t"+description+"\t"+location+"\t"+";".join(rnaBams)+"\t"+";".join(dnaBams))

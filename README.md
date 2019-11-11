# YVA tooling for pst archives processing

## How to use
```bash 
# login to tooling repo using credentials provided by YVA
user@host:~$ docker login yvatools.azurecr.io
Username: ******
Password: ******

# get this repository
user@host:~$ git clone https://github.com/yva/pst
cd pst

# start processing
# due to long work times its better to use screen utility
screen -S yva
user@host:~/pst$./up.sh --from ~/archive --to ~/results

```

## up.sh arguments

* --from **dir**: path to *pst* archive folder, all files with pst extentions will be processed.
* --to **dir**: path to *results* folder, after processing there will be several.
* --logs **dir**: path to *logs* folder, if not set results folder will be used. be defaut *result folder*/logs
* --force: reporcess files already processed
* --rebuild: rebuid pst files summary information (use after PST archive updates)
* --correct-perms **user**: set user for correcting permissions, default is the user who run script
* --no-correct-perms: dont correct permissions after finish
* -d daemon mode

## Requirements

### software

 * docker
 * docker-compose
 * bash 3.4


## permissions

Docker user root user inside container, so after tooling complets is unuseful to get files which are owned by root. To prevent this tooling make chown to *results* and *logs* folders. This behavior can be managed by --correct-perms && --no-correct-perms parameters

# YVA tooling for pst archives processing

## How to use
```bash 
# login to tooling repo using credentials provided by YVA
user@host:~$ docker login yvatools.azurecr.io
Username:
Password:

# get this repository
user@host:~$ git clone https://github.com/yva/pst
cd pst

# start processing
user@host:~/pst$./up.sh --from ~/archive --to ~/results

```

## possible arguments

* --from: path to pst archive, all files with pst extentions will be processed.
* --to: path to results folder, after processing there will be several.
* --logs: path to logs folder, if not set results folder will be used.
* --force: reporcess files already processed
* --rebuild: rebuid pst files summary information (use after PST archive updates)

## Requirements

Archive should be available for reading for user uid:gid 10000:10000
results & logs dirs shold be available for writing for user uid:gid 10000:10000
For example you cat get access for all users:
Structure: 
``` bash
  # /srv/data
  # /srv/out
  # /srv/logs

  cd /srv 
  chmod ugo+rwx out logs
  chmod ugo+rx data
```
  
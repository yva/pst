MKFILE_DIR:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))
DATA := $(MKFILE_DIR)test
FROM := $(DATA)/data
TO := $(DATA)/result
LOCAL := --local
OPT := 

define CMD
	./up.sh --from "$(FROM)" --to "$(TO)" $(OPT) $(LOCAL)
endef

rebuild:
	$(CMD) --rebuild

continue:
	$(CMD)

force:
	$(CMD) --rebuild --force

short: FROM = $(DATA)/data/albert_meyers
short: 
	$(CMD) --rebuild

debug: FROM = $(DATA)/data/albert_meyers
debug: clean
	$(CMD) --debug --rebuild --remove

clean:
	rm -rf "$(TO)"
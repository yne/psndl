PKGI_CATEGO := games dlcs themes avatars demos updates emulators apps tools
PKGI_PREFIX := pkgi_
PKGI_SUFFIX := .csv
PKGI_TARGET := $(addprefix $(PKGI_PREFIX),$(addsuffix $(PKGI_SUFFIX),$(PKGI_CATEGO)))
RAPS_TARGET := $(addsuffix .rap, $(shell awk -F, '{print $$5}' db.csv))

all: config.txt $(PKGI_TARGET) $(RAPS_TARGET)
clean:; rm -f config.txt $(PKGI_TARGET) $(RAPS_TARGET)

config.txt:; echo $(PKGI_CATEGO) | tr ' ' '\n' |awk '{print "url_"$$1" https://yne.fr/psndl/'$(PKGI_PREFIX)'"$$1"'$(PKGI_SUFFIX)'"}' > $@
$(PKGI_PREFIX)%$(PKGI_SUFFIX): db.csv; awk -F, 'BEGIN {type="$@";sub(/pkgi_/,"",type);sub(/.csv/,"",type);print "contentid,type,name,description,rap,url,size,checksum"} type == $$4 {print $$1"-"$$2"_00-0000112223333000,"$$4","$$6",-,"$$5",http://zeus.dl.playstation.net/cdn/"$$2"/"$$1"_00/"$$3".pkg,0,"}' $^ > $@
%.url: %.csv; awk -F, '{print "http://zeus.dl.playstation.net/cdn/"$$2"/"$$1"_00/"$$3".pkg"}' $^ > $@
%.dup: %.csv; awk -F, '{print $$1"/"$$2"/"$$3}' $^ | sort | uniq -d
%.rap: db.csv; printf %s $(basename $(notdir $@)) | xxd -r -p - > $@

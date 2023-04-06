all: config.txt pkgi_games.csv pkgi_dlcs.csv pkgi_themes.csv pkgi_avatars.csv pkgi_demos.csv pkgi_updates.csv pkgi_emulators.csv pkgi_apps.csv pkgi_tools.csv
config.txt:; echo "games dlcs themes avatars demos updates emulators apps tools" | tr ' ' '\n' |awk '{print "url_"$$1" https://yne.fr/psndl/pkgi_"$$1".csv"}' > $@
pkgi_%.csv: db.csv; awk -F "," 'BEGIN {type="$@";sub(/pkgi_/,"",type);sub(/.csv/,"",type);print "contentid,type,name,description,rap,url,size,checksum"} type == $$4 {print $$1"-"$$2"_00-0000112223333000,"$$4","$$6",-,"$$5",http://zeus.dl.playstation.net/cdn/"$$2"/"$$1"_00/"$$3".pkg,0,"}' $^ > $@
%.url: %.csv; awk -F "," '{print "http://zeus.dl.playstation.net/cdn/"$$2"/"$$1"_00/"$$3".pkg"}' $^ > $@
%.dup: %.csv; awk -F "," '{print $$1"/"$$2"/"$$3}' $^ | sort | uniq -d

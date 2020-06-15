.PHONY: default
default: img_stamp
named: ../bin/named
	cp $< $@

named.img: ../images/named.img
	cp $< $@

img_stamp: named named.img etc/named/named.conf etc/named/hoge.zone
	docker build . -t runu-named
	touch $@

etc/named/named.conf: ../named.conf
	mkdir -p etc/named
	cp ../named.conf ./etc/named/

etc/named/hoge.zone: ../hoge.zone
	mkdir -p etc/named
	cp ../hoge.zone ./etc/named/

.PHONY: test
test: img_stamp
	./test.sh

.PHONY:clean
clean:
	rm -rf named.img img_stamp named lkl.json etc

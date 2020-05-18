.PHONY: default
default: img_stamp
named: ../bin/named
	cp $< $@

named.img: ../images/named.img
	cp $< $@

img_stamp: named named.img
	docker build . -t runu-named
	touch $@

.PHONY: test
test: img_stamp
	./test.sh

.PHONY:clean
clean:
	rm -rf named.img img_stamp named lkl.json

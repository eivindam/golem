SHELL:=/bin/bash
default: download-all
LANG=en
download-all:
	mkdir -p data
	rm -r data/*
	$(MAKE) en
	$(MAKE) sv
	$(MAKE) fr
	$(MAKE) es
	$(MAKE) de
	$(MAKE) no
	rm -r data/*.zip
	go get -u github.com/jteeuwen/go-bindata/...
	go-bindata -pkg dicts -o dicts/data.go -nocompress data/

en: LANG=en
en: download

sv: LANG=sv
sv: download

fr: LANG=fr
fr: download

es: LANG=es
es: download

de: LANG=de
de: download

no: LANG=no
no: download

download:
	@if [ "$(LANG)" = "no" ]; then \
		curl http://diskant.no/norwegianwordbank/$(LANG).gz > data/$(LANG).gz; \
	else \
		curl http://www.lexiconista.com/Datasets/lemmatization-$(LANG).zip > data/$(LANG).zip; \
		unzip data/$(LANG).zip -d data; \
		mv data/lemmatization-$(LANG).txt data/$(LANG); \
		gzip data/$(LANG); \
	fi;

benchcmp:
	# ensure no govenor weirdness
	# sudo cpufreq-set -g performance
	go test -test.benchmem=true -run=NONE -bench=. ./... > bench_current.test
	git stash save "stashing for benchcmp"
	@go test -test.benchmem=true -run=NONE -bench=. ./... > bench_head.test
	git stash pop
	benchcmp bench_head.test bench_current.test

profile:
	@mkdir -p pprof/
	go test -run=NONE -cpuprofile pprof/cpu.prof -memprofile pprof/mem.prof -bench .
	go tool pprof -pdf pprof/cpu.prof > pprof/cpu.pdf
	xdg-open pprof/cpu.pdf
	go tool pprof -weblist=.* pprof/cpu.prof

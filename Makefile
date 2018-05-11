NPROC=`grep -c ^processor /proc/cpuinfo`

build:
	./configure.sh $(VERSION)
	cd `cat .build.target` && MAKEFLAGS="-j$(NPROC)" makepkg -sc
	rm .build.target
clean:
	rm -rf build*/
	rm .build.target

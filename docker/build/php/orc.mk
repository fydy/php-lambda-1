SHELL := /bin/bash
.DEFAULT_GOAL := make_ork
url_ork = http://gstreamer.freedesktop.org/data/src/orc/orc-${VERSION_ORC}.tar.xz
build_dir_ork = ${DEPS}/ork

fetch_ork:
	mkdir -p ${build_dir_ork}
	${CURL} -Ls ${url_ork} | tar $(shell ${TARGS} ${url_ork}) ${build_dir_ork} --strip-components=1

configure_ork:
	cd ${build_dir_ork} && \
	${build_dir_ork}/configure \
        --prefix=${TARGET} \
        --enable-shared \
        --disable-static \
        --disable-dependency-tracking

build_ork:
	cd ${build_dir_ork} && \
	$(MAKE) install-strip
	rm -rf ${TARGET}/lib/liborc-test-*

version_ork:
	cat ${VERSIONS_FILE} | ${JQ} --unbuffered --arg orc ${VERSION_ORC} '.libraries += {orc: $$orc}' > ${VERSIONS_FILE}

make_ork: fetch_ork configure_ork build_ork version_ork

require rsync.inc


SRC_URI += "file://acinclude.m4 \
"

SRC_URI[md5sum] = "0f758d7e000c0f7f7d3792610fad70cb"
SRC_URI[sha256sum] = "ecfa62a7fa3c4c18b9eccd8c16eaddee4bd308a76ea50b5c02a5840f09c0a1c2"

PACKAGECONFIG ??= "acl attr"
PACKAGECONFIG[acl] = "--enable-acl-support,--disable-acl-support,acl,"
PACKAGECONFIG[attr] = "--enable-xattr-support,--disable-xattr-support,attr,"

# rsync 3.0 uses configure.sh instead of configure, and
# makefile checks the existence of configure.sh
do_configure_prepend () {
	rm -f ${S}/configure ${S}/configure.sh
	cp -f ${WORKDIR}/acinclude.m4 ${S}/

	# By default, if crosscompiling, rsync disables a number of
	# capabilities, hardlinking symlinks and special files (i.e. devices)
	export rsync_cv_can_hardlink_special=yes
	export rsync_cv_can_hardlink_symlink=yes
}

do_configure_append () {
	cp -f ${S}/configure ${S}/configure.sh
}

BBCLASSEXTEND = "native"

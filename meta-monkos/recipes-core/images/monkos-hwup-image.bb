SUMMARY = "Monk OS basic Hardware Up Image"

LICENSE = "CLOSED"

inherit core-image

IMAGE_FEATURES += "splash"

IMAGE_ROOTFS_SIZE ?= "8192"

IMAGE_INSTALL += "\
        packagegroup-core-boot \
        ${ROOTFS_PKGMANAGE_BOOTSTRAP} \
        ${CORE_IMAGE_EXTRA_INSTALL} \
        packagegroup-monkos-baserootfs \
        "


SYSLINUX_LABELS_VM ?= "boot"
LABELS_VM ?= "${SYSLINUX_LABELS_VM}"

# Using an initramfs is optional. Enable it by setting INITRD_IMAGE_VM.
INITRD_IMAGE_VM ?= ""
INITRD_VM ?= "${@'${DEPLOY_DIR_IMAGE}/${INITRD_IMAGE_VM}-${MACHINE}.cpio.gz' if '${INITRD_IMAGE_VM}' else ''}"
do_bootdirectdisk[depends] += "${@'${INITRD_IMAGE_VM}:do_image_complete' if '${INITRD_IMAGE_VM}' else ''}"

# need to define the dependency and the ROOTFS for directdisk
do_bootdirectdisk[depends] += "${PN}:do_image_ext4"
ROOTFS ?= "${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.ext4"

# creating VM images relies on having a hdddirect so ensure we inherit it here.
inherit boot-directdisk

IMAGE_TYPEDEP_vmdk = "ext4"
IMAGE_TYPEDEP_vdi = "ext4"
IMAGE_TYPEDEP_qcow2 = "ext4"
IMAGE_TYPEDEP_hdddirect = "ext4"
IMAGE_TYPES_MASKED += "vmdk vdi qcow2 hdddirect"

create_vmdk_image () {
    qemu-img convert -O vmdk ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.hdddirect ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.vmdk
    ln -sf ${IMAGE_NAME}.vmdk ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.vmdk
}

create_vdi_image () {
    qemu-img convert -O vdi ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.hdddirect ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.vdi
    ln -sf ${IMAGE_NAME}.vdi ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.vdi
}

create_qcow2_image () {
    qemu-img convert -O qcow2 ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.hdddirect ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.qcow2
    ln -sf ${IMAGE_NAME}.qcow2 ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.qcow2
}

python do_vmimg() {
    if 'vmdk' in d.getVar('IMAGE_FSTYPES', True):
        bb.build.exec_func('create_vmdk_image', d)
    if 'vdi' in d.getVar('IMAGE_FSTYPES', True):
        bb.build.exec_func('create_vdi_image', d)
    if 'qcow2' in d.getVar('IMAGE_FSTYPES', True):
        bb.build.exec_func('create_qcow2_image', d)
}

addtask vmimg after do_bootdirectdisk before do_image_complete
do_vmimg[depends] += "qemu-native:do_populate_sysroot"


#
# build kernerl 4.x using vagrant and itamae
#
PWD=$(shell pwd)

KERNEL_VER=$(shell curl -s https://www.kernel.org | grep stable: -A1 | tail -1 | perl -nle '/>([^<]+)</; print $$1')
BUILD_DIR=$(PWD)/build/linux-$(KERNEL_VER)

all: itamae

stable: itamae

itamae: vagrant
	KERNEL_VER=$(KERNEL_VER) itamae ssh -l debug --vagrant roles/build-kernel-4.x.y-for-centos6.rb

vagrant:
	vagrant up || vagrant plugin install vagrant-persistent-storage

size:
	vagrant ssh -c "df -h"

clean:
	-rm -rf $(BUILD_DIR)
	vagrant ssh -c "cd /usr/local/src/kernel-build/ && make KERNEL_VER=$(KERNEL_VER) clean"

clobber:
	vagrant ssh -c "rm -rf ~/rpmbuild/* && sudo rm -rf /usr/local/src/kernel-build"


AICP_BRANCH=t

# AICP RELEASE VERSION
AICP_VERSION_MAJOR = 18
AICP_VERSION_MINOR = 0
AICP_VERSION_MAINTENANCE = 0

PRODUCT_VERSION_MAJOR := $(AICP_VERSION_MAJOR)
PRODUCT_VERSION_MINOR := $(AICP_VERSION_MINOR)
PRODUCT_VERSION_MAINTENANCE := $(AICP_VERSION_MAINTENANCE)

VERSION := $(AICP_VERSION_MAJOR).$(AICP_VERSION_MINOR)

ifndef AICP_BUILDTYPE
    ifdef RELEASE_TYPE
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^AICP_||g')
        AICP_BUILDTYPE := $(RELEASE_TYPE)
    else
        AICP_BUILDTYPE := UNOFFICIAL
    endif
endif

ifdef AICP_BUILDTYPE
    ifeq ($(AICP_BUILDTYPE), NIGHTLY)
        AICP_VERSION := $(TARGET_PRODUCT)_$(AICP_BRANCH)-$(VERSION)-NIGHTLY-$(shell date -u +%Y%m%d)
    endif
    ifeq ($(AICP_BUILDTYPE), WEEKLY)
       AICP_VERSION := $(TARGET_PRODUCT)_$(AICP_BRANCH)-$(VERSION)-WEEKLY-$(shell date -u +%Y%m%d)
    endif
    ifeq ($(AICP_BUILDTYPE), EXPERIMENTAL)
        AICP_VERSION := $(TARGET_PRODUCT)_$(AICP_BRANCH)-$(VERSION)-EXPERIMENTAL-$(shell date -u +%Y%m%d)
    endif
    ifeq ($(AICP_BUILDTYPE), UNOFFICIAL)
        AICP_VERSION := $(TARGET_PRODUCT)_$(AICP_BRANCH)-$(VERSION)-UNOFFICIAL-$(shell date -u +%Y%m%d)
    endif
else
#We reset back to UNOFFICIAL
        AICP_VERSION := $(TARGET_PRODUCT)_$(AICP_BRANCH)-$(VERSION)-UNOFFICIAL-$(shell date -u +%Y%m%d)
endif

# Signing
ifneq (eng,$(TARGET_BUILD_VARIANT))
ifneq (,$(wildcard vendor/aicp/signing/keys/releasekey.pk8))
PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/aicp/signing/keys/releasekey
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.oem_unlock_supported=1
endif
ifneq (,$(wildcard vendor/aicp/signing/keys/otakey.x509.pem))
PRODUCT_OTA_PUBLIC_KEYS := vendor/aicp/signing/keys/otakey.x509.pem
endif
endif

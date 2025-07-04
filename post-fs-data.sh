#!/system/bin/sh
# (c) 2025 mrdoge0, Free Software Licensed under Apache-2.0

# 99,999999999% of "vendor" filesystems come from stock ROMs or conventional custom ROMs, so they have the correct device info.
VENDORPROP="/vendor/build.prop"

if [ -f "$VENDORPROP" ]; then
    # Get source props.
    VENDORBRAND=$(grep -E 'ro.product.vendor.brand=' "$VENDORPROP" | cut -d'=' -f2)
    VENDORDEVICE=$(grep -E 'ro.product.vendor.device=' "$VENDORPROP" | cut -d'=' -f2)
    VENDORMANUFACTURER=$(grep -E 'ro.product.vendor.manufacturer=' "$VENDORPROP" | cut -d'=' -f2)
    VENDORMODEL=$(grep -E 'ro.product.vendor.model=' "$VENDORPROP" | cut -d'=' -f2)

    # Do the props.
    if [ ! -z "$VENDORDEVICE" ]; then
        resetprop -n ro.product.brand "$VENDORBRAND"
        resetprop -n ro.product.device "$VENDORDEVICE"
        resetprop -n ro.product.manufacturer "$VENDORMANUFACTURER"
        resetprop -n ro.product.model "$VENDORMODEL"
        resetprop -n ro.product.product.brand "$VENDORBRAND"
        resetprop -n ro.product.product.device "$VENDORDEVICE"
        resetprop -n ro.product.product.manufacturer "$VENDORMANUFACTURER"
        resetprop -n ro.product.product.model "$VENDORMODEL"
        resetprop -n ro.product.system.brand "$VENDORBRAND"
        resetprop -n ro.product.system.device "$VENDORDEVICE"
        resetprop -n ro.product.system.manufacturer "$VENDORMANUFACTURER"
        resetprop -n ro.product.system.model "$VENDORMODEL"
        resetprop -n ro.product.system_ext.brand "$VENDORBRAND"
        resetprop -n ro.product.system_ext.device "$VENDORDEVICE"
        resetprop -n ro.product.system_ext.manufacturer "$VENDORMANUFACTURER"
        resetprop -n ro.product.system_ext.model "$VENDORMODEL"
        resetprop -n ro.product.bootimage.brand "$VENDORBRAND"
        resetprop -n ro.product.bootimage.device "$VENDORDEVICE"
        resetprop -n ro.product.bootimage.manufacturer "$VENDORMANUFACTURER"
        resetprop -n ro.product.bootimage.model "$VENDORMODEL"
    fi

    # Market name support - Separate from standard resetprops because some devices don't have marketname props.
    ODMMN=$(grep -E 'ro.product.vendor.marketname=' "/odm/etc/build.prop" | cut -d'=' -f2)
    if [ ! -z $ODMMN ]; then
        resetprop -n ro.product.marketname "$ODMMN"
        resetprop -n ro.product.system.marketname "$ODMMN"
        resetprop -n ro.product.system_ext.marketname "$ODMMN"
        resetprop -n ro.product.product.marketname "$ODMMN"
        resetprop -n ro.product.vendor.marketname "$ODMMN"
        resetprop -n ro.product.system_dlkm.marketname "$VENDORDEVICE"
        resetprop -n ro.product.bootimage.marketname "$VENDORDEVICE"
    fi

    # A new experimental feature - fixing fingerprints (usable for Play Integrity)
    SYSTEMPROP="/system/build.prop"
    SYSTEMNAME=$(grep -E 'ro.system.build.fingerprint=' "$SYSTEMPROP" | cut -d'=' -f2 | cut -d'/' -f2 | cut -d'/' -f1)
    SYSTEMVER=$(grep -E 'ro.build.version.release_or_codename=' "$SYSTEMPROP" | cut -d'=' -f2)
    SYSTEMID=$(grep -E 'ro.build.id=' "$SYSTEMPROP" | cut -d'=' -f2)
    SYSTEMINC=$(grep -E 'ro.build.version.incremental=' "$SYSTEMPROP" | cut -d'=' -f2)
    SYSTEMTYPE=$(grep -E 'ro.build.type=' "$SYSTEMPROP" | cut -d'=' -f2)
    SYSTEMTAGS=$(grep -E 'ro.build.tags=' "$SYSTEMPROP" | cut -d'=' -f2)

    # Vendor fingerprint
    VENDORNAME=$(grep -E 'ro.product.vendor.name=' "$VENDORPROP" | cut -d'=' -f2 | cut -d'/' -f2 | cut -d'/' -f1)
    VENDORVER=$(grep -E 'ro.vendor.build.version.release_or_codename=' "$VENDORPROP" | cut -d'=' -f2)
    VENDORID=$(grep -E 'ro.vendor.build.id=' "$VENDORPROP" | cut -d'=' -f2)
    VENDORINC=$(grep -E 'ro.vendor.build.version.incremental=' "$VENDORPROP" | cut -d'=' -f2)
    VENDORTYPE=$(grep -E 'ro.vendor.build.type=' "$VENDORPROP" | cut -d'=' -f2)
    VENDORTAGS=$(grep -E 'ro.vendor.build.tags=' "$VENDORPROP" | cut -d'=' -f2)

    # Example result: "Xiaomi/aosp_arm64/lavender:15/BP1A.250305.001/example:userdebug/test-keys"
    TRUEFINGERPRINT="$VENDORBRAND/$SYSTEMNAME/$VENDORDEVICE:$SYSTEMVER/$SYSTEMID/$SYSTEMINC:$SYSTEMTYPE/$SYSTEMTAGS"
    resetprop -n ro.build.fingerprint "$TRUEFINGERPRINT"
    resetprop -n ro.system.build.fingerprint "$TRUEFINGERPRINT"
    resetprop -n ro.system_ext.build.fingerprint "$TRUEFINGERPRINT"
    resetprop -n ro.product.build.fingerprint "$TRUEFINGERPRINT"

    # Example result: "aosp_arm64-userdebug 15 BP1A.250305.001 example test-keys"
    TRUEDESC="$SYSTEMNAME-$SYSTEMTYPE $SYSTEMVER $SYSTEMID $SYSTEMINC $SYSTEMTAGS"
    resetprop -n ro.build.description "$TRUEDESC"
    resetprop -n ro.system.build.description "$TRUEDESC"
    resetprop -n ro.system_ext.build.description "$TRUEDESC"
    resetprop -n ro.product.build.description "$TRUEDESC"

    # True vendor fingerprint (sometimes they are spoofed)
    TRUEVENFP="$VENDORBRAND/$VENDORNAME/$VENDORDEVICE:$VENDORVER/$VENDORID/$VENDORINC:$VENDORTYPE/$VENDORTAGS"
    TRUEVENDESC="$VENDORNAME-$VENDORTYPE $VENDORVER $VENDORID $VENDORINC $VENDORTAGS"
    resetprop -n ro.vendor.build.fingerprint "$TRUEVENFP"
    resetprop -n ro.vendor_dlkm.build.fingerprint "$TRUEVENFP"
    resetprop -n ro.odm.build.fingerprint "$TRUEVENFP"
    resetprop -n ro.bootimage.build.fingerprint "$TRUEVENFP"
    resetprop -n ro.vendor.build.description "$TRUEVENDESC"
    resetprop -n ro.vendor_dlkm.build.description "$TRUEVENDESC"
    resetprop -n ro.odm.build.description "$TRUEVENDESC"
    resetprop -n ro.bootimage.build.description "$TRUEVENDESC"

    # bonus
    resetprop -n ro.build.flavor "$SYSTEMNAME-$SYSTEMTYPE"

    # Report your success.
    echo "Fix_GSI_Identity_Crisis: Operation finished"
    setprop ro.fix_gsi_identity_crisis.job_successful "1"
else
    echo "Fix_GSI_Identity_Crisis: Operation FAILED"
    setprop ro.fix_gsi_identity_crisis.job_successful "0"
fi

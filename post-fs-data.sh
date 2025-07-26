#!/system/bin/sh
# (c) 2025 mrdoge0, Modified to spoof user builds — Apache-2.0 Licensed

VENDORPROP="/vendor/build.prop"

if [ -f "$VENDORPROP" ]; then
    VENDORBRAND=$(grep -E 'ro.product.vendor.brand=' "$VENDORPROP" | cut -d'=' -f2)
    VENDORDEVICE=$(grep -E 'ro.product.vendor.device=' "$VENDORPROP" | cut -d'=' -f2)
    VENDORMANUFACTURER=$(grep -E 'ro.product.vendor.manufacturer=' "$VENDORPROP" | cut -d'=' -f2)
    VENDORMODEL=$(grep -E 'ro.product.vendor.model=' "$VENDORPROP" | cut -d'=' -f2)

    if [ ! -z "$VENDORDEVICE" ]; then
        for part in "" ".product" ".system" ".system_ext" ".bootimage"; do
            resetprop -n ro.product${part}.brand "$VENDORBRAND"
            resetprop -n ro.product${part}.device "$VENDORDEVICE"
            resetprop -n ro.product${part}.manufacturer "$VENDORMANUFACTURER"
            resetprop -n ro.product${part}.model "$VENDORMODEL"
        done
    fi

    ODMMN=$(grep -E 'ro.product.vendor.marketname=' "/odm/etc/build.prop" | cut -d'=' -f2)
    if [ ! -z "$ODMMN" ]; then
        for part in "" ".system" ".system_ext" ".product" ".vendor" ".system_dlkm" ".bootimage"; do
            resetprop -n ro.product${part}.marketname "$ODMMN"
        done
    fi

    SYSTEMPROP="/system/build.prop"
    SYSTEMNAME=$(grep -E 'ro.system.build.fingerprint=' "$SYSTEMPROP" | cut -d'=' -f2 | cut -d'/' -f2 | cut -d'/' -f1)
    SYSTEMVER=$(grep -E 'ro.build.version.release_or_codename=' "$SYSTEMPROP" | cut -d'=' -f2)
    SYSTEMID=$(grep -E 'ro.build.id=' "$SYSTEMPROP" | cut -d'=' -f2)
    SYSTEMINC=$(grep -E 'ro.build.version.incremental=' "$SYSTEMPROP" | cut -d'=' -f2)

    # Spoofed type & tags for user builds
    SPOOF_TYPE="user"
    SPOOF_TAGS="release-keys"

    VENDORNAME=$(grep -E 'ro.product.vendor.name=' "$VENDORPROP" | cut -d'=' -f2 | cut -d'/' -f2 | cut -d'/' -f1)
    VENDORVER=$(grep -E 'ro.vendor.build.version.release_or_codename=' "$VENDORPROP" | cut -d'=' -f2)
    VENDORID=$(grep -E 'ro.vendor.build.id=' "$VENDORPROP" | cut -d'=' -f2)
    VENDORINC=$(grep -E 'ro.vendor.build.version.incremental=' "$VENDORPROP" | cut -d'=' -f2)

    TRUEFINGERPRINT="$VENDORBRAND/$SYSTEMNAME/$VENDORDEVICE:$SYSTEMVER/$SYSTEMID/$SYSTEMINC:$SPOOF_TYPE/$SPOOF_TAGS"
    TRUEDESC="$SYSTEMNAME-$SPOOF_TYPE $SYSTEMVER $SYSTEMID $SYSTEMINC $SPOOF_TAGS"

    for part in "" ".system" ".system_ext" ".product"; do
        resetprop -n ro.build${part}.fingerprint "$TRUEFINGERPRINT"
        resetprop -n ro.build${part}.description "$TRUEDESC"
    done

    TRUEVENFP="$VENDORBRAND/$VENDORNAME/$VENDORDEVICE:$VENDORVER/$VENDORID/$VENDORINC:$SPOOF_TYPE/$SPOOF_TAGS"
    TRUEVENDESC="$VENDORNAME-$SPOOF_TYPE $VENDORVER $VENDORID $VENDORINC $SPOOF_TAGS"

    for part in ".vendor" ".vendor_dlkm" ".odm" ".bootimage"; do
        resetprop -n ro${part}.build.fingerprint "$TRUEVENFP"
        resetprop -n ro${part}.build.description "$TRUEVENDESC"
    done

    resetprop -n ro.build.flavor "$SYSTEMNAME-$SPOOF_TYPE"

    echo "Fix_GSI_Identity_Crisis: Operation finished (user spoof)"
    setprop ro.fix_gsi_identity_crisis.job_successful "1"
else
    echo "Fix_GSI_Identity_Crisis: Operation FAILED"
    setprop ro.fix_gsi_identity_crisis.job_successful "0"
fi
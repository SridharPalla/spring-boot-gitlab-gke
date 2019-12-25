#!/bin/sh
if kubectl -n "$KUBE_NAMESPACE" get secret retail-pim-ingress-cert >/dev/null 2>/dev/null; then
    echo "Ingress cert OK"
else
    echo "$DEV_ING_CERT" > tls.crt
    echo "$DEV_ING_KEY" > tls.key
    if kubectl -n "$KUBE_NAMESPACE" create secret tls retail-pim-ingress-cert --cert=tls.crt --key=tls.key; then
        echo "Ingress cert created successfully" && rm -f tls.crt tls.key
        exit 0
    else
        echo "Failed to create the ingress certificate" && rm -f tls.crt tls.key
        exit 1    
    fi
fi
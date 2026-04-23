#!/bin/bash
# Limita el historial de cliphist a los últimos 500 elementos para ahorrar RAM/Disco

COUNT=$(cliphist list | wc -l)
LIMIT=500

if [ "$COUNT" -gt "$LIMIT" ]; then
    # Obtener los IDs de los elementos excedentes y borrarlos
    cliphist list | tail -n +$((LIMIT + 1)) | cliphist delete
fi

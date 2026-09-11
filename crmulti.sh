#!/bin/bash

export ORACLE_BASE=/opt/app/oracle/
export ORACLE_HOME=/opt/app/oracle/product/19CR3
export PATH=$ORACLE_HOME/bin:$PATH

SYS_PASS='Oracle@123'
SYSTEM_PASS='Oracle@123'

tail -n +2 databases.csv | while IFS=, read DB SID MEM CHARSET DATA FRA
do
    echo "Creating database $DB..."

    export ORACLE_SID=$SID

    dbca -silent -createDatabase \
        -templateName General_Purpose.dbc.new \
        -gdbName $DB \
        -sid $SID \
        -createAsContainerDatabase false \
        -sysPassword "$SYS_PASS" \
        -systemPassword "$SYSTEM_PASS" \
        -storageType FS \
        -datafileDestination $DATA \
        -recoveryAreaDestination $FRA \
        -characterSet $CHARSET \
        -automaticMemoryManagement false \
        -totalMemory $MEM \
        -sampleSchema false \
        -emConfiguration NONE

    if [ $? -eq 0 ]; then
        echo "$DB created successfully."
    else
        echo "Failed to create $DB."
    fi
done

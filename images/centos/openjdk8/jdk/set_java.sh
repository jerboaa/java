#!/bin/bash
JAVA_32=$(alternatives --display java | grep family | grep i386 | cut -d' ' -f1)
alternatives --set java ${JAVA_32}
exit $? 

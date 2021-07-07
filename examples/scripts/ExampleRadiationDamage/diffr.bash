#!/bin/bash
IN_DIR=/gpfs/exfel/data/user/juncheng/skopi/examples/scripts/ExampleRadiationDamage
BIN=/gpfs/exfel/data/user/juncheng/skopi/bin/radiationDamageMPI
OUT_DIR=diffr

$BIN \
    --inputDir $IN_DIR  \
    --outputDir $OUT_DIR  \
	--uniformRotation 1 \
    --geomFile ./agipd_simple_2d.geom   \
    --calculateCompton 1   \
    --sliceInterval 10   \
    --numSlices 100   \
    --pmiStartID 1   \
    --pmiEndID 1   \
    --numDP 20
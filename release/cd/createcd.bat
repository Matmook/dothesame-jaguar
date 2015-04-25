echo "boot"
MAKETRK -b1E7000 -z bjlboot.abs
PADCD +100000 bjlboot.t00 bjlboot.raw
echo "game"
MAKETRK -z -t1 -mTRAK dtscd.abs
PADCD +100000 dtscd.T01 dtscd.RAW
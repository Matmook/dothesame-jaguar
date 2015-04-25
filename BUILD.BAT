
@del *.o
@del release\*.bin
 
mac -dBJLVERSION=1 -s -fb -g -u core.s 
aln -o release\dts.bin -n -w -rq -a 4000 x x core.o mooklib/sebsnd.o
@del *.o

mac -dCDVERSION=1 -s -fb -g -u core.s 
aln -o release\dtscd.bin -n -w -rq -a 4000 x x core.o mooklib/sebsnd.o
@del *.o

mac -dSKUNKVERSION=1 -s -fb -g -u core.s 
aln -o release\dtsskunk.bin -n -w -rq -a 4000 x x core.o mooklib/sebsnd.o
@del *.o

cd release
@del *.jag
@del *.rom
cd ..

# aosp-8

docker build aosp 8

## docker command

docker run
```
docker run -v $HOME:/mnt/aosp -v $HOME/ssd2:/mnt/ssd2 -it --rm --name aosp-tam1 erwinchang/aosp-800 /bin/bash
```

enable aosp ccache
```
prebuilts/misc/linux-x86/ccache/ccache -M 10G
source build/envsetup.sh
lunch sabresd_6dq-userdebug
make -j4 2>&1 | tee build-log.txt
```

## 參考來源

- [sameersbn/docker-ubuntu][1]
- [kylemanna/docker-aosp][2]
- [AOSP build environment][3]


[1]:https://github.com/sameersbn/docker-ubuntu/tree/14.04
[2]:https://github.com/kylemanna/docker-aosp
[3]:https://source.android.com/setup/initializing#setting-up-a-linux-build-environment


[parm]:title             = 'Tatin: OneDrive'
[parm]:toc               = 3
[parm]:leanpubExtensions = 1
[parm]:numberHeaders     = 2 3 4 5 6




# Tatin and OneDrive


## Background 

OneDrive is cloud storage offered by Microsoft for backing up some of your personal folders.

In the context of Tatin, the folder `Documents\` is of particular interest.

For decades, Dyalog has saved stuff in a version agnostic folder named "XXXXX" in this folder, and also version specific stuff. For example, for version 19.0 there is a folder "YYYYYY" created in `Documents/`.

Until version 0.114.0 Tatin  questioned the envornment `USERPROFILE` in order to find out where to copy Tatin to. For example, for a user JohnDoe that would usually result in

```
C:\Users\JohnDoe\Documents\
```

This is true no matter whether OneDrive is used or not.


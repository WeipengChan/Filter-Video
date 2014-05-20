# InstaFilters
*Instagram filters hacked and open sourced. Supports both photo and video.*

![1 jpg](https://lh5.googleusercontent.com/-caU0skbslrU/T0_J1mADGTI/AAAAAAAAACQ/z8-tTTzvkPU/s576/1.jpg)
![2 jpg](https://lh6.googleusercontent.com/-em6NqhxtTSc/T0_J1wWj0_I/AAAAAAAAACU/7hWbNr99fZg/s576/2.jpg)
![3 jpg](https://lh5.googleusercontent.com/-4daHWyaGrHE/T0_J2RdcHkI/AAAAAAAAACg/mtYAWmY9qP4/s576/3.jpg)

### What's It About
**InstaFilters** is an (almost) fully fledged open sourced implementation of Instagram's real-time filters view controller. It implements all of Instagram's 17 real-time filters, including **Sierra**, the latest one. Like Instagram, InstaFilters runs on an iPhone. But there's one more thing, it supports both photo and video.

### Yes It's A Hack
The most important part, the OpenGL ES shader files and color mapping files that are critical to all those beautiful colors and effects of real-time video filtering, are literally hacked from the Instagram app. But no, the hacking is not difficult, since Instagram hardly spent any effort in hiding them before they released their 2.1 version.

###How It Works
Real-time video filtering relies heavily on the GPU of your iPhone. And no, you can't talk to your GPU through Objective-C. **InstaFilters** does talk to the GPU, but not in a direct way. It is built upon [GPUImage](https://github.com/BradLarson/GPUImage), a beautifully written open sourced framework by [Brad Larson](http://stackoverflow.com/users/19679/brad-larson) that hanles low-level GPU interactions on **InstaFilters**'s behalf.

But GPUImage is written for general purposes OpenGL ES handling and currently only supports up to 2 textures in one filter while Instagram takes up to 5 textures and requires dynamic filter switching in run time. To port Instagram's recipes downwards into GPUImage's low-level APIs, **InstaFilters** subclasses a few key componets of GPUImage, extends their abilities and makes sure they are Instagram-friendly.

At the same time, **InstaFilters** also implements the upper-level MVC structure with the help of UIKit. And takes care of the background asynchronous tasks of recording, writing, mixing and saving of audio and video files with the help of the AVFoundation framework.

### Video Recording
Video recording is a natual extention of the real-time video filtering realm and therefore shouldn't be too hard to implement. But it is, actually, a problem, when, let's say, you want to share and upload your filtered video right after you have finished shooting them. Oh, and don't forget the audio tracks, you definitely don't want your friends to only get the muted version.

**InstaFilters** deals with the audio recording by itself, the video recording through GPUImage, and then the mixing of audio and video by itself. In the best case scenario, with lightweighted filters such as **Inkwell** and **Amaro**, an average frame rate (fps) of 18 could be reached on an iPhone 4 with a output resolution of 480 pixel x 480 pixel. But when it comes to the worst case scenario, with filters such as **Sutro** and **hefe**, the fps would drop to 8. 

###Environment
1. An iPhone device
2. iOS 5.0+
2. Xcode setup

###Known Issues
The following filters still have minor defetcts. Am working on them now.

1. Sierra
2. Earlybird
3. Xpro II

###License
Since it's a hack, literally. There's no way you could use those Instagram recipes in your project. But feel free to learn from them. Other than that part, you are welcome to use and distribute this project. I'll figour out an appropriate license and put it here later.

###Video Demo
[Video recording demo with the filter **Inkwell**](http://www.youtube.com/watch?v=ea4imL_XW34)

###Contact Me
[@diwup](http://twitter.com/diwup)

<diwufet@gmail.com>
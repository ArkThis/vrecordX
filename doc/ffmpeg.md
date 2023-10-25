# Information regarding FFmpeg on the capture side

2023-10-25


# Output during capture:

`1337.00 A-V: -0.033 fd=   1 aq=    0KB vq= 1620KB sq=    0B f=0/0`

  * `1337.00`       Seconds since recording has started
  * `fd`            Number of frames dropped
  * `A-V`           Timing offset between Audio and Video
  * `M-V` or `M-A`  Video-only or Audio-only.
  * `aq`            Audio Queue size
  * `vq`            Video Queue size
  * `sq`            Subtitle Queue size
  * `f=m/n`         PTS correction: **m=**number of *faulty DTS*, **n=**number of *faulty PTS*

In [FFmpeg's source code for 'fftools/ffplay.c' (around line #1705)](https://git.ffmpeg.org/gitweb/ffmpeg.git/blob/HEAD:/fftools/ffplay.c#l1704), you see the block where this line is put together:

```
av_bprintf(&buf,
   "%7.2f %s:%7.3f fd=%4d aq=%5dKB vq=%5dKB sq=%5dB f=%"PRId64"/%"PRId64"   \r",
   get_master_clock(is),
   (is->audio_st && is->video_st) ? "A-V" : (is->video_st ? "M-V" : (is->audio_st ? "M-A" : "   ")),
   av_diff,
   is->frame_drops_early + is->frame_drops_late,
   aqsize / 1024,
   vqsize / 1024,
   sqsize,
   is->video_st ? is->viddec.avctx->pts_correction_num_faulty_dts : 0,
   is->video_st ? is->viddec.avctx->pts_correction_num_faulty_pts : 0);
```


## Links

  * ["What are mv, fd, aq, vq, sq and f in a video stream?" (Stackoverflow.com)](https://stackoverflow.com/questions/27778678/what-are-mv-fd-aq-vq-sq-and-f-in-a-video-stream)



# Glossary

  * DTS: Decode TimeStamp
  * PTS: Presentation TimeStamp


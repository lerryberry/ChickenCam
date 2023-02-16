placeholder="https://github.com/lerryberry/ChickenCam/blob/4f5bd91e0c4b0692d64b21e2f31e3c8333486c8c/backup/placeholder-offline.jpg"
imageName=$(basename $placeholder)
$(curl $placeholder)
$(pkill "ffmpeg")
$(sleep 2)

$(
  ffmpeg -loop 1 -framerate 30 \
    -f lavfi \
      -i anullsrc c:a aac \
    -i $imageName \
      -c:v libx264 -pix_fmt yuv420p \
  -f flv rtmp://a.rtmp.youtube.com/live2/3sa2-heh8-0yhb-tgcz-41ef
)

function out=rgbBackgroundToBlack(in,background_mask)
out=zeros(size(in));
for channel=1:3
    this=squeeze(in(:,:,channel));
    this(background_mask)=0;
    out(:,:,channel)=this;
end
    
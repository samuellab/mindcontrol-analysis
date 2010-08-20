function cmap2 = redbluecmap(rampexp)

cmap2 = zeros(64,3);

c_red = [1 0 0];
c_blue = [0 0 1];

ramp1 = ([32:-1:1]'/32).^rampexp;
ramp2 = ([1:32]'/32).^rampexp ;

cmap2(1:32,:) = repmat(ramp1, [1 3]) .* repmat(c_blue, [32 1]);
cmap2(33:64,:) = repmat(ramp2, [1 3]) .* repmat(c_red, [32 1]); 
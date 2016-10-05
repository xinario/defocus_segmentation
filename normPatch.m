function im_out = normPatch(im, varargin)
%can handle min-max l1 l2 normaliztion.
norm_type = parse_inputs(varargin);


if strcmp(norm_type,'show')
    im_out = im - min(im(:));
    im_out = im_out/max(im_out(:));
elseif strcmp(norm_type,'l1')
    im_out = im/sum(im(:));
    
elseif strcmp(norm_type,'l2')
    im_out = im/sqrt(sum(im(:).^2));
end




function norm_type = parse_inputs(varargin)
% Parse arguments based on their number.
switch(length(varargin{:}))
    
    case 0
        norm_type = 'show';
    case 1
        norm_type = varargin{1,1}(1);
end
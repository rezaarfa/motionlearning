function D = track2grid(Tracks, imW, imH, grSizeW, grSizeH, offset)

%TRACK2GRID converts track to grid using 1d codebook!
%   D = TRACK2GRID(Tracks, imW, imH, grSizeW, grSizeH) convert all tracks
%   in Tracks to codebook. It is assumed that the top left corner of the
%   image corresponds to track (0, 0) (this is important only if you want
%   to plot the track)
% 
%    (0,0)
%  _|_____________________X___
%   |1  |4  |7  |10 |
%   |___|___|___|___| 
%   |2  |5  |8  |11 |
%   |___|___|___|___|
%   |3  |6  |9  |12 |
%   |___|___|___|___| Gw = 4 x Gh = 3
%   |    <--> 
%   |  grSizeW  
%   y
%   |
%   TRACK2GRID then return a vector of size L = (imW/grSizeW)*(imH/grSizeH) 
%   which assign 1 to position met by track and 0 other wise. you retrive 
%   the image by 
%                   imagesc_binary(reshape(D(:,1), Gh, Gw))
% 
% 
%   Inputs
%   -------------
%   Tracks  {1-by-N}    :   tracks
% 
%   imW     [INT]       :   width of the image
% 
%   imH     [INT]       :   height of the image
% 
%   grSizeW [INT]       :   size of grides in X direction. it should be
%                           divideable to imW
% 
%   grSizeH [INT]       :   size of grides in Y direction. it should be
%                           divideable to imH
%   grSizeH [2-by-1]    :   if your tracks are not at the same coordinate
%                           of the image, you can adjust it by this add an
%                           offsset
% 
% 
% 
%   Outputs
%   -------------
%   D       [SPARSE]    :   (L-by-N) Gridized tracks. L is  
%                               L = grSizeW/imgW * grSizeH/imgH
% 
%   Reza Arfa, JUN 2015

if nargin<6
    offset = [];
end

N = length(Tracks);
if rem(imW, grSizeW)~=0 || rem(imH, grSizeH)~=0 
    fprintf('imW : %i / %i = %f \n', imW, grSizeW, rem(imW, grSizeW));
    fprintf('imH : %i / %i = %f \n', imH, grSizeH, rem(imH, grSizeH));
    error('grSizeW and grSizeH should be divideable to imW and imH');
end

Gw = imW / grSizeW;         % number of Grids in width
Gh = imH / grSizeH;         % number of Grids in height

L = Gw * Gh;

D = sparse(L, N);

intervalW = 0:grSizeW:imW;  % 1 x (Gw + 1)
intervalH = 0:grSizeH:imH;  % 1 x (Gh + 1)

barTracket = floor(N/20);
counter = 0;
fprintf('=>track 2 grids ');

for i = 1:N
    temp = Tracks{i};
    if ~isempty(offset)
        temp = bsxfun(@plus,temp,offset);
    end
    X = temp(1,:);
    Y = temp(2,:);

    D(:,i) = track2grid_single_track(X, Y, intervalW, intervalH, Gw, Gh);
    
    counter = counter+1;
    if rem(counter,barTracket)==0
        fprintf('.');
    end
end

fprintf('\n');


end





% -------------------------------------------
function C = track2grid_single_track(X, Y, intervalW, intervalH, Gw, Gh)
C = sparse(Gh*Gw, 1);

xw = which_interval(X, intervalW); % in the range of {1,..,Gw}  
xh = which_interval(Y, intervalH); % in the range of {1,..,Gh}

C(sub2ind([Gh,Gw],xh,xw))=1;
end




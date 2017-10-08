function out=asystem(inp, noise, nonlin)

% out=asystem(inp, noise, nonlin)
% 
% inp: input signal
% noise: random noise in dB, []...no noise
% nonlin: level of non linear distortion in dB
% out: output signal

% Piotr Majdak (2005)
% 7.10.2012: rand->randn

out=inp;

Num = [   0.0000
    -5.12647033139024e-012
    -3.05186174549543e-010
     7.77177996883202e-009
     5.71843181126212e-008
     1.59284450912272e-007
     1.40012492537556e-007
    -4.51740554319933e-007
    -1.88285908173696e-006
    -3.08042879299088e-006
    -9.07959307894563e-007
     8.05083006068758e-006
     2.26984248815111e-005
     3.33521202568038e-005
     2.48364240881428e-005
    -1.10841233232514e-005
    -6.22510439858297e-005
    -9.65115842093654e-005
    -8.24553849248365e-005
    -1.65749583947911e-005
     6.93488206253438e-005
      0.000132363221541066
      0.000152511180829438
      0.000139024001638617
     9.77390299195139e-005
     4.06364978567601e-008
     -0.000190951294865685
     -0.000438063966801512
     -0.000577959323516569
     -0.000398730108435197
       0.00016339000094647
       0.00087001547998189
       0.00125802331704353
      0.000960514217430671
     3.34267955834532e-005
      -0.00101934478938891
      -0.00159497936391029
      -0.00143202804968176
     -0.000740360039516884
     9.26789490519049e-005
      0.000888908430735118
       0.00170297740751174
       0.00242470639004165
       0.00245591146909963
       0.00103155820088505
      -0.00187717794553814
      -0.00492611481892047
      -0.00592661348490147
      -0.00346845159423988
       0.00163069798426416
       0.00649143789174074
       0.00812084607329124
       0.00562053446020117
      0.000708514598575869
      -0.00391742252229866
      -0.00675245201076857
      -0.00799241706787956
      -0.00793760205755369
      -0.00534094316316169
       0.00175979848917663
        0.0127112648009308
         0.021762195154158
        0.0202975373097587
       0.00421167044031946
       -0.0199578081080669
       -0.0379201943507255
       -0.0383557071638279
       -0.0208776621006385
       0.00767264301232439
        0.0435685405476569
        0.0889828804705536
         0.142371231187061
         0.189255378601462
         0.208332411645766
         0.189255378601462
         0.142371231187061
        0.0889828804705536
        0.0435685405476569
       0.00767264301232438
       -0.0208776621006385
       -0.0383557071638279
       -0.0379201943507255
       -0.0199578081080669
       0.00421167044031946
        0.0202975373097587
         0.021762195154158
        0.0127112648009308
       0.00175979848917663
      -0.00534094316316169
      -0.00793760205755369
      -0.00799241706787956
      -0.00675245201076857
      -0.00391742252229866
      0.000708514598575869
       0.00562053446020117
       0.00812084607329124
       0.00649143789174074
       0.00163069798426415
      -0.00346845159423988
      -0.00592661348490147
      -0.00492611481892046
      -0.00187717794553814
       0.00103155820088505
       0.00245591146909963
       0.00242470639004165
       0.00170297740751174
      0.000888908430735118
     9.26789490519049e-005
     -0.000740360039516885
      -0.00143202804968176
      -0.00159497936391029
      -0.00101934478938891
     3.34267955834531e-005
      0.000960514217430671
       0.00125802331704353
       0.00087001547998189
       0.00016339000094647
     -0.000398730108435197
     -0.000577959323516569
     -0.000438063966801512
     -0.000190951294865685
     4.06364978567619e-008
     9.77390299195139e-005
      0.000139024001638617
      0.000152511180829438
      0.000132363221541066
     6.93488206253438e-005
     -1.6574958394791e-005
    -8.24553849248365e-005
    -9.65115842093654e-005
    -6.22510439858297e-005
    -1.10841233232514e-005
     2.48364240881428e-005
     3.33521202568038e-005
     2.26984248815111e-005
     8.05083006068758e-006
    -9.07959307894563e-007
    -3.08042879299088e-006
    -1.88285908173696e-006
    -4.51740554319933e-007
     1.40012492537556e-007
     1.59284450912272e-007
     5.71843181126212e-008
     7.77177996883202e-009
    -3.05186174549543e-010
    -5.12647033139024e-012  
    0.0000];

out=conv(out,Num);
out=out(1:length(inp));  


if exist('nonlin','var')
  out=interp(out,16);   % upsample 16 times to avoid aliasing
  etu=max(out)*(1-10^(nonlin/20));
  etl=min(out)*(1-10^(nonlin/20));
  out(find(out>etu))=etu;
  out(find(out<etl))=etl;
  out=decimate(out,16); % downsample
end


if exist('noise','var')
  if ~isempty(noise)
    out=out+randn(length(out),1)*10^(noise/20);
  end
end

%A wrapper for a hertbeat detection program
function Detector(record)
  fileName = sprintf('pretvorjeni/%sm.mat', record);
  t = cputime();
  
  M = 5;    % dolžina filtra
  WS = 10;  % dolžina drsečega okna
  WSDecision = 180; 
  idx = QRSDetect(fileName, M, WS, WSDecision);
  
  fprintf('Running time: %f\n', cputime() - t);
  asciName = sprintf('detektirano/%s.det', record);
  fid = fopen(asciName, 'wt');
  for i=1:size(idx, 2)
      fprintf(fid,'0:00:00.00 %d N 0 0 0\n', idx(1, i) );
  end
  
  fclose(fid);
  
  rec = sprintf('podatki/%s', record);
  wrann(rec,'qrs', idx(1,:)');
  
end
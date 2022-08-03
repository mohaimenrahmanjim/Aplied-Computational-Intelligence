function [mergedSS] = mergeSwapSequence(rA, sA, rB, sB)
  sA = [sA];
  sb = [sB];
  
  if rA > 1
    rA = 1.0;
  end
  
  if rB > 1
    rB = 1.0;
  end
  
  sizeA = floor(size(sA,1)*rA);
  sizeB = floor(size(sB,1)*rB);
  
  if sizeA > 0
    sA = sA(1:sizeA,:);
  end
  
  if sizeB > 0
    sB = sB(1:sizeB,:);
  end
  
  mergedSS = [sA; sB];
end
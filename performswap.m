function [A] = peformSwap(A, SS)
  n = size(SS,1);
  for i=1:n
    indexI = SS(i,1);
    indexJ = SS(i,2);
    temp = A(1,indexI);
    A(1,indexI) = A(1,indexJ);
    A(1,indexJ) = temp;
  end
end

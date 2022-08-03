% A - B = SS (SwapSequence)

function [swapSequence] = findSwapSequence(A, B)
  swapSequence = [];
  n=size(A,2);
  for i=1:n
    for j=1:n
      if A(1,i)==B(1,j)
        if not(i==j) 
          swapSequence = [swapSequence; [i,j]];
        end
        temp = B(1,i);
        B(1,i) = B(1,j);
        B(1,j) = temp;
       break
      end
    end
  end
end


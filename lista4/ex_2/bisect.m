function [answer,iflag] = bisect(fun,a,b)
global tolerance maxits
% BISECT: Calcula zeros de uma função via o metodo da bisseção 
% ver pg 113, livro Otto
% --------------------------------------------------------------------------
%  answer,iflag = bisect(fun,a,b)
%
% func    -  nome do script da funcao fornecida      (in)
% a       -  inicio do intervalo                       (in)
% b       -  final do intervalo                        (in)
% 
% answer-  raiz da funcao                             (out)
% iflag-   indicador do tipo de solucao encontrada    (out)
% --------------------------------------------------------------------------
% Criado:       
%
% Modificado:    
% -------------------------------------------------------------------------
%
iflag = 0;
iterations = 0;
f_a = feval(fun,a);
f_b = feval(fun,b);
%
%
%
while ((f_a*f_b<0) & iterations<maxits) & (b-a)>tolerance
       iterations  = iterations + 1;
       c  = (b+a)/2;
       f_c = feval(fun,c);
       if f_c*f_a<0
          b = c;, f_b = f_c;
       else if f_b*f_c<0
          a = c;, f_a = f_c;
       else
          iflag = 1; answer = c;
       end
end
%
%
%
switch iterations
 case maxits
     iflag = -1; answer = NaN;
 case  0
     iflag = -2; answer = NaN;
 otherwise
     iflag = iterations; answer = c;
end
end

 


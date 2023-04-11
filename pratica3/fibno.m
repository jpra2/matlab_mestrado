function fib = fibno(n)
% Calcular números de Fibonacci

    fib = 1;
    if n > 2
        f = [ 1 1]; i=1;
        while i+2 <= n
            f(i+2) = f(i) + f(i+1);
            i=i+1;
        end
        fib = f(n);
    end
    what
end
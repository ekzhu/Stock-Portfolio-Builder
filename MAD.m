function [Portfolio, Volatility, PortfolioReturn] = MAD(RateOfReturn)
    
    num_stocks = length(RateOfReturn(1,:));
    num_period = length(RateOfReturn(:,1));
    mean_rors = zeros(1, num_stocks);
    for i=1:num_stocks
        % Calculate mean rate of return of stock i
        mean_rors(i) = geomean(RateOfReturn(:,i)+1) - 1;
    end
    
    minR = min(mean_rors);
    maxR = max(mean_rors);
    R = minR:0.005:maxR; % Portfolio return values, the target return of portfolio
    
    objfunc = [zeros(num_stocks,1); ones(num_period*2,1)];
    Volatility = zeros(1, length(R));
    Portfolio = zeros(length(objfunc), length(R));

    % Deviation matrix for all stocks
    deviations = RateOfReturn - repmat(mean_rors, num_period, 1);

    Aeq = [deviations -eye(num_period) eye(num_period); ...
        mean_rors zeros(1,num_period*2); ...
        ones(1,num_stocks) zeros(1,num_period*2)];

    lb = [repmat(-inf,num_stocks,1); zeros(num_period*2, 1)];

    for i = 1:length(R)
        beq = [zeros(num_period,1); R(i); 1];
        [Portfolio(:,i) fval exitflag output] = linprog(objfunc,[],[],Aeq,beq,lb,[]);
        % Find portfolio variance from the LP solution
        Volatility(i) = (fval*(1/num_period)*sqrt(pi/2))^2;
    end
    Portfolio = Portfolio(1:num_stocks,:);
    PortfolioReturn = R;
end
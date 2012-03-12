function [Portfolio, Volatility, PortfolioReturn] = MVO(RateOfReturn)
% MVO: Mean Variance Optimization Method
% RateOfReturn: Matrix, each column is a stock and each row is a period
% RateOfReturn(i,j): the rate of return of stock j in period i
    num_stocks = length(RateOfReturn(1,:));
    mean_rors = zeros(1, num_stocks);
    for i=1:num_stocks
        % Calculate mean rate of return of stock i
        mean_rors(i) = geomean(RateOfReturn(:,i)+1) - 1;
    end
    % Calculate the covariance between returns of stocks
    covar = cov(RateOfReturn);
    % disp('The covariance matrix:');
    % disp(covar);
    
    minR = min(mean_rors);
    maxR = max(mean_rors);
    R = minR:0.005:maxR; % Portfolio return values, the target return of portfolio
    
    Volatility = zeros(1, length(R)); % Portfolio volatilities (variance)
    Portfolio = zeros(num_stocks, length(R));
    % lb = zeros(length(stocks),1);
    % Find optimized portfolios for different returns, using MVO
    for i = 1:length(R)
        Aeq = [mean_rors; ones(1,num_stocks)];
        beq = [R(i); 1];
        [Portfolio(:,i) Volatility(i) exitflag output] = quadprog(covar,[],[],[],Aeq,beq,[],[]);
    end
    PortfolioReturn = R;
end
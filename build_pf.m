% Run it with hist_stock_data.m in the same directory

%% User defined parameters
StartDate = '01012010'; % ddmmyyyy
EndDate = '01022012';
Tickers = 'tickers_eg.txt'; % All tickers are defined in tickers.txt
Frequency = 'm'; % Set desired frequency of stock quotes, d-day m-month

%% Retrieve and analyze stock statistics
% Retrieve stocks data from Finance Yahoo.
stocks = hist_stock_data(StartDate, EndDate, Tickers, 'frequency', Frequency);

num_period = length(stocks(1).Date) - 1;
rors = zeros(num_period, length(stocks));
mean_rors = zeros(1, length(stocks));

% Calculate rate of return (ror), mean, and variance of ror of each stock
for i=1:length(stocks)
    stocks(i).ror = zeros(num_period, 1); % Rate of return of stocks i
    
    % Calculate all rate of return of stock i
    for j=1:num_period
        % Total Returns
        I1 = stocks(i).Open(j)/stocks(i).Close(j);
        I2 = stocks(i).Open(j+1)/stocks(i).Close(j+1);
        % Rate of returns
        stocks(i).ror(j) = (I2 - I1)/I1;
    end
    rors(:,i) = stocks(i).ror;
    
    % Calculate mean rate of return of stock i
    stocks(i).mean = geomean(stocks(i).ror+1) - 1;
    mean_rors(i) = stocks(i).mean;
    
    % Calculate the variance of the ror of stock i
    stocks(i).var = var(stocks(i).ror);
    
    fprintf('Stock: %s\n', stocks(i).Ticker);
    fprintf('Mean = %f\n', stocks(i).mean);
    fprintf('Var = %f\n\n', stocks(i).var);
end

% Calculate the covariance between returns of stocks
covar = cov(rors);
disp('The covariance matrix:');
disp(covar);

minR = min(mean_rors);
maxR = max(mean_rors);
R = minR:0.005:maxR; % Portfolio return values

%% MVO
Volatility_MVO = zeros(1, length(R)); % Portfolio volatilities (variance)
Portfolio_MVO = zeros(length(stocks), length(R));
% lb = zeros(length(stocks),1);
% Find optimized portfolios for different returns, using MVO
for i = 1:length(R)
    Aeq = [mean_rors; ones(1,length(stocks))];
    beq = [R(i); 1];
    [Portfolio_MVO(:,i) Volatility_MVO(i) exitflag output] = quadprog(covar,[],[],[],Aeq,beq,[],[]);
end

%% LP
objfunc = [zeros(length(stocks),1); ones(num_period*2,1)];
Volatility_LP = zeros(1, length(R));
Portfolio_LP = zeros(length(objfunc), length(R));

% Deviation matrix for all stocks
deviations = rors - repmat(mean_rors, num_period, 1);

Aeq = [deviations -eye(num_period) eye(num_period); ...
    mean_rors zeros(1,num_period*2); ...
    ones(1,length(stocks)) zeros(1,num_period*2)];

lb = [repmat(-inf,length(stocks),1); zeros(num_period*2, 1)];

for i = 1:length(R)
    beq = [zeros(num_period,1); R(i); 1];
    [Portfolio_LP(:,i) fval exitflag output] = linprog(objfunc,[],[],Aeq,beq,lb,[]);
    % Find portfolio variance from the LP solution
    Volatility_LP(i) = (fval*(1/num_period)*sqrt(pi/2))^2;
end

%% Graph
plot(Volatility_MVO, R, '*', Volatility_LP, R, '.');
xlabel('Volatility');
ylabel('Subject Return');
% axis([0 0.005 -0.1 0.1]);

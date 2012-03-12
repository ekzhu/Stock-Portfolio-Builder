% Run it with hist_stock_data.m in the same directory

%% User defined parameters
StartDate = '01012010'; % ddmmyyyy
EndDate = '01022012';
Tickers = 'tickers_eg.txt'; % All tickers are defined in tickers.txt
Frequency = 'm'; % Set desired frequency of stock quotes, d-day m-month
Outputfile = 'result.csv'; % Set the output file, .csv recommanded
Method = 'MVO'; % Available: 'MVO', 'MAD', ...
Graph = false; % true if you want to graph the efficiency frontier

%% Retrieve and analyze stock statistics
% Retrieve stocks data from Finance Yahoo.
stocks = hist_stock_data(StartDate, EndDate, Tickers, 'frequency', Frequency);

num_period = length(stocks(1).Date) - 1;
rors = zeros(num_period, length(stocks));

% Calculate rate of return (ror), mean, and variance of ror of each stock
for i=1:length(stocks)
    stocks(i).ror = zeros(num_period, 1); % Rate of return of stocks i
    
    % Calculate all rate of return of stock i
    for j=1:num_period
        % Rate of returns
        stocks(i).ror(j) = (stocks(i).Open(j+1) - stocks(i).Open(j))/stocks(i).Open(j);
    end
    rors(:,i) = stocks(i).ror;
end

%% MVO
if strcmp(Method, 'MVO')    
    [Portfolio, Volatility, R] = MVO(rors);
end
%% MAD
if strcmp(Method, 'MAD')
    [Portfolio, Volatility, R] = MAD(rors);
end
%% Graph
if Graph
    plot(Volatility, R, '*');
    xlabel('Volatility');
    ylabel('Subject Return');
    % axis([0 0.005 -0.1 0.1]);
end
%% Write result to file
out = fopen(Outputfile, 'w');
fprintf(out, 'Portfolio Returns,');
for i=1:length(R)
    fprintf(out, '%.4f,', R(i));
end
fprintf(out, '\nVolatilities,');
for i=1:length(Volatility)
    fprintf(out, '%.4f,', Volatility(i));
end
fprintf(out, '\nStocks Portfolio Weights\n');
for i=1:length(Portfolio(:,1))
    fprintf(out, '%s,', stocks(i).Ticker);
    for j=1:length(Portfolio(1,:))
        fprintf(out, '%.4f,', Portfolio(i,j));
    end
    fprintf(out, '\n');
end
function [ train_data ] = standardizace( train_data )

    for i = 1:size(train_data, 2) % -x : x
          priznak = train_data(:,i);
          MEAN = mean(priznak);
          STD = std(priznak);
          train_data(:,i) = (priznak-MEAN) / (STD);
    end
    
end


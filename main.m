%% Authors: 
% Alex Brandimarte
% Jangwon Park
% Sowmya Tata
% Tony Ye

%% Read & Take out rows with missing data
data = readtable('aggregateData.csv',  'Delimiter' , ',' );

%% ingredients: matrix of ingredients for each recipe
% Row: Ingredients
% Column: Recipes

ingredients = data(:, 31:end);
ingredients = table2array(ingredients);
[n_recipe,n_ing] = size(ingredients);
ingredients = transpose(ingredients);
recipenames = table2array(data(:, 'RecipeName'));
ingnames = data.Properties.VariableNames(31:end);  % vector of ingredient names

%% User Input Parameters

% Preferred cuisines 1 / 0 encoding
% Asian, Central American, European, Indian, Italian, Mediterranean, North American, 
UC = [1 1 1 1 1 1 1 ];

% Preferred flavors 1 / 0 encoding
%piquant, meaty,   bitter, sweet, sour, salty
UF = [1 1 1 1 1 1];
Cooktime_limit = 200;
MaxIng_Num = 20;

%Health details
isMale = true;
Age = 23;
ActivityLevel = 3; % 1 = sedentary, 2 = moderate, 3 = active

%%% Weights for soft constraints rewards
%Cons1: exceed recommended for good nutrients
%Cons2: exceed less than 5% of bad nutrients
%Cons3: less than specified cooktime
%Cons4: preferred cuisine
%Cons5: preferred flavours
%Cons6: maximum ingredient
Weights = [1 1 1 1 1 1];

%User's ingredients and amounts
%avail_IngNames = ["oats","milk","banana", "apple", "anchovies", "sugar", "pork", "lamb", "salt", "pepper", "lettuce", "tomatoes", "bread"];
% Specify amounts for each
% avail_IngAmounts = [5,2,3,5,1, ....]
% For entered ingredients, below assumes you have 500 units of each
%[placeholder, n_numavail] = size(avail_IngNames);
%avail_IngAmounts = zeros(1, n_numavail);
%avail_IngAmounts(1,:) = 500; 

% %Set up the matrix
% indices = arrayfun(@(x) find(ingnames == x,1,'first'), avail_IngNames) % get corresponding indices
% [placeholder,n_ing] = size(ingnames);
% A = zeros(n_ing, 1);
% for idx = 1:numel(indices)
%     A(indices(idx),1) = avail_IngAmounts(idx);
% end

% Assume user has all ingredients
A = ones(n_ing,1);
A(:,1) = 200;

%%%% User Custom Recommendation Amounts
%'Protein', 'Carbs', 'Fibre', 'TotalFat', 'Iron', 'VitaminC','Sodium', 'Calcium'
% M_n = [52,130,38,101.111111100000,0.0110000000000000,0.0750000000000000,2.30000000000000,1.30000000000000, 2600];

%% Import Nutritional Recommendation Data 
male_n = readtable('MaleValues.csv' , 'Delimiter' , ',' );
female_n = readtable('FemaleValues.csv' , 'Delimiter' , ',' );

%% Get Nutritional Recommended Amounts
M_n = [];
if (isMale)
    M_n = table2array(male_n(male_n.Age==Age, {'Protein', 'Carbs', 'Fibre', 'TotalFat', 'Iron', 'VitaminC','Sodium', 'Calcium'}));
    calories = table2array(male_n(male_n.Age==Age, ActivityLevel+1));% calories amount
    M_n = [M_n calories];
else
    M_n = table2array(female_n(female_n.Age==Age, {'Protein', 'Carbs', 'Fibre', 'TotalFat', 'Iron', 'VitaminC','Sodium', 'Calcium'}));
    calories = table2array(female_n(female_n.Age==Age, ActivityLevel+1));% calories amount
    M_n = [M_n calories];
end

%% Nutrients: matrix of nutrients
% Row: nutrients
% Column: recipes

nutrients = data(:, 7:15);
nutrients = table2array(nutrients);
[n_recipe,n_nutrients] = size(nutrients);
nutrients = transpose(nutrients);

%% Get cooktimes
% vector of cooktimes for all recipes (minutes)
cooktimes = data(:, 4);
cooktimes = table2array(cooktimes);
cooktimes = cooktimes';

%% Get Ingredient numbers
% vector of # of ingredients for all recipes
num_ingredient_recipes = data(:, 29);
num_ingredient_recipes = table2array(num_ingredient_recipes);
num_ingredient_recipes = num_ingredient_recipes';

%% Get cuisines
 % matrix of cuisine types
cuisines = data(:, 16:22);
cuisines = table2array(cuisines);
[~,n_cuisines] = size(cuisines);
cuisines = transpose(cuisines);

%% Get flavors
% matrix of flavors 
flavors = data(:, 23:28);
flavors = table2array(flavors);
[~,n_flavors] = size(flavors);
flavors = transpose(flavors);

%%
%M_n = [2400,60,80,2300];
% A = ones(n_ing,1); % assume the user has all ingredients for now
bigM = 10e5;
%n_softcons = 2; % protein, calories
n_softcons = 6;
n_sn = [4 5 1 7 6 1]; % # of s_n's for each b_i term
% 2 b's, 2 sn's
% x is dimension: # of recipes + 4
%%
a1 = cat(2, ingredients, zeros(n_ing,n_softcons + sum(n_sn)));
a2 = cat(2, ones(1,n_recipe), zeros(1,n_softcons + sum(n_sn)));
a1_rhs = A; 
a2_rhs = 3;

%%
a3 = cat(2, nutrients, zeros(n_nutrients,n_softcons + sum(n_sn)));
a3_rhs = 0.75* M_n';

%%
indices = [3 5 6 8];
nut_submat4 = nutrients(indices,:);
%nut_submat4 = nutrients(2,:);
a4 = nut_submat4; %matrix of nutrients: fibre,iron, vitamin C,calcium % protein
a4 = cat(2, a4, zeros(4,n_softcons));
%a4 = cat(2, a4, zeros(1,n_softcons)); % add zeros for the b's
%bigM_matrix = [-bigM];
bigM_matrix = zeros(4, sum(n_sn));
bigM_matrix(1,3) = - bigM;
bigM_matrix(2,5) = - bigM;
bigM_matrix(3,6) = - bigM;
bigM_matrix(4,8) = - bigM;
a4 = cat(2,a4, bigM_matrix);
%a4 = cat(2, a4, zeros(1,1)); % remove
a4_rhs = M_n(indices) - bigM;
a4_rhs = a4_rhs';
%a4_rhs = M_n(2) - bigM * ones(size(M_n(2))); %remove

%%
indices = [1 2 4 7 9];
a6 = nutrients(indices,:);
%a6 = nutrients(1,:); % calories
%a6 = cat(2, a6, zeros(1, n_softcons + sum(n_sn)));
a6 = cat(2, a6, zeros(5, n_softcons + sum(n_sn)));
a6_rhs = 2*M_n(indices);
a6_rhs = a6_rhs';
%a6_rhs = 2*M_n(1);

%%
indices = [1 2 4 7 9];

a7_rhs = 1.05*M_n(indices) + bigM;
a7_rhs = a7_rhs';

a7 = nutrients(indices,:);
bigM_matrix = zeros(5, sum(n_sn));
bigM_matrix(1,1) = bigM;
bigM_matrix(2,2) = bigM;
bigM_matrix(3,4) = bigM;
bigM_matrix(4,7) = bigM;
bigM_matrix(5,9) = bigM;
a7 = cat(2, a7, zeros(5,n_softcons));
a7 = cat(2,a7, bigM_matrix); 

%% New constraints
%Cooktime
a8 = cat(2, cooktimes, zeros(1,n_softcons));
bigM_matrix = zeros(1, sum(n_sn));
bigM_matrix(1,10) = bigM;
a8 = cat(2,a8, bigM_matrix);
a8_rhs = [Cooktime_limit + bigM];

%Preferred Cuisines
a9 = cuisines;
a9 = cat(2, a9, zeros(7,n_softcons));
bigM_matrix = zeros(7, sum(n_sn));
bigM_matrix(1,11) = -bigM;
bigM_matrix(2,12) = -bigM;
bigM_matrix(3,13) = -bigM;
bigM_matrix(4,14) = -bigM;
bigM_matrix(5,15) = -bigM;
bigM_matrix(6,16) = -bigM;
bigM_matrix(7,17) = -bigM;
a9 = cat(2,a9, bigM_matrix);


a9_2sub = zeros(7, sum(n_sn));
a9_2sub(1,11) = 1;
a9_2sub(2,12) = 1;
a9_2sub(3,13) = 1;
a9_2sub(4,14) = 1;
a9_2sub(5,15) = 1;
a9_2sub(6,16) = 1;
a9_2sub(7,17) = 1;
a9_2 = cat(2, zeros(7,n_recipe+n_softcons),a9_2sub); 

a9_rhs1 = ones(7,1) - bigM;
a9_rhs2 = UC';

%Preferred Flavors

a10 = flavors;
a10 = cat(2, a10, zeros(6,n_softcons));
bigM_matrix = zeros(6, sum(n_sn));
bigM_matrix(1,18) = -bigM;
bigM_matrix(2,19) = -bigM;
bigM_matrix(3,20) = -bigM;
bigM_matrix(4,21) = -bigM;
bigM_matrix(5,22) = -bigM;
bigM_matrix(6,23) = -bigM;
a10 = cat(2,a10, bigM_matrix);


a10_2sub = zeros(6, sum(n_sn));
a10_2sub(1,18) = 1;
a10_2sub(2,19) = 1;
a10_2sub(3,20) = 1;
a10_2sub(4,21) = 1;
a10_2sub(5,22) = 1;
a10_2sub(6,23) = 1;
a10_2 = cat(2, zeros(6,n_recipe+n_softcons),a10_2sub); 

a10_rhs1 = ones(6,1)*0.5 - bigM;
a10_rhs2 = UF';

%# of Ingredients
a11 = cat(2, num_ingredient_recipes, zeros(1,n_softcons));
bigM_matrix = zeros(1, sum(n_sn));
bigM_matrix(1,24) = bigM;
a11 = cat(2,a11, bigM_matrix);
a11_rhs = [MaxIng_Num + bigM];

%% set b values
b1_indices = [3 5 6 8];
b2_indices = [1 2 4 7 9];
b3_index = [10];
b4_indices = [11 12 13 14 15 16 17];
b5_indices = [18 19 20 21 22 23];
b6_indices = [24];

%Exceed good nutrients
b1_vec2 = zeros(1,sum(n_sn));
b1_vec2(b1_indices) = -Weights(1)/4.0;
b1_vec1 = zeros(1,n_softcons);
b1_vec1(1) = 1;

% Less than. Bad nutrients
b2_vec2 = zeros(1,sum(n_sn));
b2_vec2(b2_indices) = -Weights(2)/5.0;
b2_vec1 = zeros(1,n_softcons);
b2_vec1(2) = 1;

% cooktime
b3_vec1 = zeros(1,n_softcons);
b3_vec1(3) = 1;
b3_vec2 = zeros(1,sum(n_sn));
b3_vec2(b3_index) = -Weights(3);

% cuisines
b4_vec1 = zeros(1,n_softcons);
b4_vec1(4) = 1;
b4_vec2 = zeros(1,sum(n_sn));
b4_vec2(b4_indices) = -Weights(4)/sum(UC);

%flavors
b5_vec1 = zeros(1,n_softcons);
b5_vec1(5) = 1;
b5_vec2 = zeros(1,sum(n_sn));
b5_vec2(b5_indices) = -Weights(5)/sum(UF);

%num_ingredients
b6_vec1 = zeros(1,n_softcons);
b6_vec1(6) = 1;
b6_vec2 = zeros(1,sum(n_sn));
b6_vec2(b6_indices) = -Weights(6);

a5_r1 = cat(2, zeros(1,n_recipe), [b1_vec1 b1_vec2]);
a5_r2 = cat(2, zeros(1,n_recipe), [b2_vec1 b2_vec2]);
a5_r3 = cat(2, zeros(1,n_recipe), [b3_vec1 b3_vec2]);
a5_r4 = cat(2, zeros(1,n_recipe), [b4_vec1 b4_vec2]);
a5_r5 = cat(2, zeros(1,n_recipe), [b5_vec1 b5_vec2]);
a5_r6 = cat(2, zeros(1,n_recipe), [b6_vec1 b6_vec2]);
a5 = [a5_r1;a5_r2;a5_r3;a5_r4;a5_r5;a5_r6];



% a5_row1 = cat(2, zeros(1,n_recipe), [1 0 -Weights(1) 0]);
% a5_row2 = cat(2, zeros(1,n_recipe), [0 1 0 -Weights(2)]);
% a5 = cat(1, a5_row1, a5_row2); 

[n,~] = size(a5);
a5_rhs = zeros(n,1);


%% Optimize
%Was doing this to debug which constraints were messed up!
%a6=[]
%a6_rhs =[]
%a7 =[]
%a7_rhs= []
%a8=[]
%a8_rhs=[]
%a9=[]
%a9_rhs1 =[]
%a10 = [] 
%a10_rhs1 =[]
%a11 = []
%a11_rhs =[]
%a9_2 = []
%a9_rhs2=[]
%a10_2=[]
%a10_rhs2=[]

result = MIE465Optimize_New(n_recipe,n_softcons,sum(n_sn),a1,a1_rhs,a2,a2_rhs,a3,a3_rhs,a4,a4_rhs,a5,a5_rhs,a6,a6_rhs,a7,a7_rhs, a8,a8_rhs,a9,a9_rhs1,a10,a10_rhs1,a11,a11_rhs, a9_2,a9_rhs2,a10_2,a10_rhs2);
result_recipes = result.x(1:length(recipenames),1);
result_SoftRewardValues = result.x(length(recipenames)+1:length(recipenames)+1+n_softcons,1);
result_sns = result.x(length(recipenames)+1+n_softcons+1 : end,1);

rows = logical(result_recipes); %0 for not chosen, 1 for chosen
vars = {'RecipeName','TotalTimeMins','Rating','Course','Cuisine','Protein','Carbohydrates','Fibre','Fat','Iron','VitC','Sodium','Calcium','Calories','NumOfIngredients'};
results_table = data(rows,vars)

function [ result ] = MIE465Optimize( num_recipes, num_rewards, num_sn, A1, A1_RHS, A2, A2_RHS, A3, A3_RHS, A4, A4_RHS, A5, A5_RHS, A6, A6_RHS, A7, A7_RHS, A8, A8_RHS, A9, A9_RHS, A10, A10_RHS, A11, A11_RHS, A9_2, A9_RHS2, A10_2, A10_RHS2)
%% Authors: 
% Alex Brandimarte
% Jangwon Park
% Sowmya Tata
% Tony Ye

%% Function description
% The function prescribes three meals out of a list of many by maximizing a
% sum of personal preferences of the user.
% Inputs:
%   M: amount of nutrient n recommended including calories (N x 1) 
% User Inputs:
%   uIng: amount of ingredients available by the user
%   Cook: max. total cooking time spent allowed by the user

%% Setting up for gurobi

% Objective
model.obj = [zeros(num_recipes,1); ones(num_rewards,1); zeros(num_sn,1)];
model.modelsense = 'max';

% Constraints
%Al = [A1;A6;A7];
Al = [A1;A6;A7;A8;A11;A9_2;A10_2];
%Ag = [A3;A4];
Ag = [A2;A3;A4;A9;A10];
Aeq = [A5];
Acombined = sparse([Al;Ag;Aeq]);
model.A = Acombined;

% Constraint signs
model.sense = [repmat('<', size(Al,1), 1); repmat('>' ,size(Ag,1), 1); repmat('=', size(Aeq,1), 1)];

% Constraint RHS
%Al_RHS = [A1_RHS; A6_RHS; A7_RHS];
Al_RHS = [A1_RHS; A6_RHS; A7_RHS;A8_RHS; A11_RHS;A9_RHS2;A10_RHS2];
%Ag_RHS = [A3_RHS; A4_RHS];
Ag_RHS = [A2_RHS;A3_RHS; A4_RHS;A9_RHS;A10_RHS];
Aeq_RHS = [A5_RHS];
model.rhs = [Al_RHS; Ag_RHS; Aeq_RHS];

% Variable types
%model.vtype = [repmat('B', num_recipes, 1); repmat('I', num_rewards, 1); repmat('B', num_sn, 1)];
% change to real value for rewards (bs)

model.vtype = [repmat('B', num_recipes, 1); repmat('C', num_rewards, 1); repmat('B', num_sn, 1)];
%% Solve using gurobi
result = gurobi(model);

end


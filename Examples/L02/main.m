% Program to modify global stiffness matrix to account for homogenous and
% non-homogenous boundary conditions
clc
clear

%% Initialisation [PRE-PROCESSING]

% Follwing are the main variables used. No explaination is given as
%       names are self explanatory.
% Number_of_nodes   
% Number_of_elements
% Global_stiffness_matrix
% Local_stiffness_matrix
% Element_incidences
%       (Information on nodes correspinding to each elements)
% Global_force_matrix

%load input.mat

% Enter global matrix
Global_stiffness_matrix = [5.5 -4.6 0 0 0;
    -4.6 14 -4.6 0 0;
     0.4 -4.6 11 -4.6 0.4;
     0 0 -4.6 14.2 -4.6;
     0 0 4.0 -4.6 6.5];

% Enter global force matrix
Global_force_matrix = [50 200 100 200 90];

Global_stiffness_matrix % Displays global stiffness matrix
Global_force_matrix % Displays global force matrix

% Enter number of nodes
Number_of_nodes = 5; 

% Enter number of elements
Number_of_elements = 4; 

%% Initialization- Boundary conditions [PRE-PROCESSING]

% loc Enter location of boundary nodes to be initialised as node numbers
% In this case boundaries corresponding to nodes 1 and 5
Boundary_nodes = [1 5]';

% Enter boundary condition displacement values in the order of
% node numbers initialised in the location matrix
Boundary_condition_displacement = [15 4]'; 


% NOTE: 'Boundary_nodes' matrix and 'Boundary_condition_displacement'
% matrix should be of the same size

%% [PROCESSING]

% For the algorithm to be used for general cases it is required to keep the
% size of Global_stiffness_matrix and Global_force_matrix to remain the
% same even after the boundary conditions are accounted for.

Number_of_known_displacements = length(Boundary_condition_displacement);

%Step 1
for i = 1:Number_of_known_displacements
    aa = Global_stiffness_matrix(Boundary_nodes(i), Boundary_nodes(i));
    Global_force_matrix(Boundary_nodes(i)) = aa * ...
				Boundary_condition_displacement(i);
    for j = 1:Number_of_nodes
        if j == Boundary_nodes(i)
            Global_stiffness_matrix(Boundary_nodes(i),j) = ...
			Global_stiffness_matrix(Boundary_nodes(i),j);
        else
            Global_stiffness_matrix(Boundary_nodes(i),j) = 0;
        end
    end
end

%Step 2
for i = 1:1:Number_of_known_displacements
    for j = 1:Number_of_nodes
        if j ~= Boundary_nodes(i)
            sum(j) = Global_stiffness_matrix(j,Boundary_nodes(i)) * ...
				Boundary_condition_displacement(i);
            Global_force_matrix(j) = Global_force_matrix(j) - sum(j);
            Global_stiffness_matrix(j,Boundary_nodes(i)) = 0
		% This line will make 1st and 5 th column=0
		% (except 1,1 and 5,5 element in our case)
        else
        end
    end
end

%% [POST-PROCESSING]

% Displays modified global stiffness matrix
Global_stiffness_matrix 
% Displays modified global force matrix
Global_force_matrix = Global_force_matrix' 

% Displays calculated displacements
Displacements = inv(Global_stiffness_matrix) * Global_force_matrix

% End of file

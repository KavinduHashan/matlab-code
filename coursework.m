%Load dataset form fisheriris.mat
load fisheriris.mat;

%Dividing dataset into the categories 
Categrical_Spec = categorical(species);
Legnth_Spec = categories(Categrical_Spec);

Oldmeas = meas;

%Randomly_shuffling ds
position_ds = randperm(length(Categrical_Spec));

for a = 1 : length(Categrical_Spec)
    meas(a,:) = meas(position_ds(a),:);
end

new_meas = meas;

%Declaring_Variable (testing and training)
%Varible for testing 
Trainig_Dta = [];
Trainig_Target = [];
%Varible for training
Testing_Dta = [];
Testing_Target = [];

%Divideding_dataset (60% for training and 40% for testing)
 for a = 1 : length(Legnth_Spec)
     ind_n = find(Categrical_Spec == Legnth_Spec{a});
    ind_n = ind_n(randperm(length(ind_n)));
    
    %traning 60%
    Trainig_Dta = [Trainig_Dta; meas(ind_n(1:round(length(ind_n)*0.6)),:)];
    Trainig_Target = [Trainig_Target; Categrical_Spec(ind_n(1:round(length(ind_n)*0.6)),:)];

    %testing 40%
    Testing_Dta = [Testing_Dta; meas(ind_n(1+round(length(ind_n)*0.6):end),:)];
    Testing_Target = [Testing_Target; Categrical_Spec(ind_n(1+round(length(ind_n)*0.6):end),:)];
end

%Encode the sring-data 
Trainig_Target = onehotencode(Trainig_Target,2);
Testing_Target = onehotencode(Testing_Target,2);

%Rotate (training_ds_by_90_degrees)
Trainig_Dta = rot90(Trainig_Dta);
Trainig_Target = rot90(Trainig_Target);

%Rotate (testing_ds_by_90_degrees)
Testing_Dta  = rot90(Testing_Dta);
Testing_Target  = rot90(Testing_Target);

%Creating a new neural network 
for a = 1 : 10 
    hiddenLyers = [5, 10, 15, 20];
    Neuarl_Network = feedforwardnet(hiddenLyers);
end
[output_trainedNetwork, tr] = train(Neuarl_Network, Trainig_Dta, Trainig_Target);

%Viwe (neuarl ds)
view(output_trainedNetwork);

%Test perform
Count_Perfomnce = 0;

for a = 1 : 50
    get_Performnce = perform(output_trainedNetwork, Testing_Target, output_trainedNetwork(Testing_Dta));
    Count_Perfomnce = Count_Perfomnce + get_Performnce;
end

%Calculate the avg_proformnce
avg_performnce = (Count_Perfomnce / 50) * 100;

%plot data
figure;
Plote1 = Oldmeas(:,1:4);
subplot(1,2,1);
gscatter(Plote1(:,1), Plote1(:,2), species, 'krb', 'xsd');
lable = categories(Categrical_Spec);
xlabel('Sepal Length');
ylabel('Sepal Width');
title('Plot Data - (before shuffle)');
hold on;

plote2 = new_meas(:,1:4);
subplot(1,2,2);
gscatter(plote2(:,1), plote2(:,2), species, 'rgb', 'd+*');
lable = categories(Categrical_Spec);
xlabel('Sepal Length');
ylabel('Sepal Width');
title('Plot Data - (after shuffle)');
hold off;
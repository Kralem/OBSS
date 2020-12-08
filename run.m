files = dir('pretvorjeni/*.mat');
matrika = zeros(7,7);
for file = files'
    name = regexprep(file.name,'m.mat','');
    Detector(name);
    
end
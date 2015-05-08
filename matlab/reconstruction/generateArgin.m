function invar = generateArgin(invar,argin)
    num_argin = size(argin,2);
    var_num = 1;
    while var_num <= num_argin
        if ischar(argin{var_num})
            if isfield(invar,argin{var_num})
                invar = setfield(invar,argin{var_num},argin{var_num + 1});
                var_num = var_num + 1;
            end
        end
        var_num = var_num + 1;
    end
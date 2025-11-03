function [marb_next, range_next] = runConstrainedBayes()
    % functions used for normalization and reverse normalization to assist
    % with the bayesian optimizer:
    norm_design = @(x,xmin, xmax) (x - xmin)/(xmax-xmin);
    rev_norm = @(x,xmin, xmax) x*(xmax-xmin) + xmin;

    global dataTable
    
    meanfunc1 = {@meanPoly, 2}; %constant mean function
    covfunc1 = @covSEard; %Squared Exponential Covariance
    likfunc1 = @likGauss;         % Gaussian likelihood 
    inffunc1 = @infGaussLik; %gaussian inference function
    
    % for the classification 
    meanfunc2 = @meanConst;
  
    likfunc2 = @likErf;
    
    inffunc2 = @infEP;
    
    hyp_init = struct('mean', [1;1;1;1], 'cov', [1;1;1], 'lik', -1);
    
    
    % Fit model using only feasible points. If all are feasible, this isn't an
    % issue. If there are infeasible ones, we need to using the imputing in the
    % next step
    xfit_all = [dataTable.Marbles, dataTable.Range];

    %normalize to assist with the bayesian optimizier
    %xfit_all(:,1) = norm_design(xfit_all(:,1),4,20);
    xfit_all(:,1) = norm_design(xfit_all(:,1),4,14);
    xfit_all(:,2) = norm_design(xfit_all(:,2),200,350);


    xfit = xfit_all(dataTable.Feasibility == 1, :);
    yfit = dataTable.Steps(dataTable.Feasibility==1);

    %normalize to assist with the bayesian optimizer
    yfit = norm_design(yfit, min(yfit), max(yfit));
    
    hyp = minimize_noprint(hyp_init, @gp, -100, inffunc1, meanfunc1, covfunc1, likfunc1, xfit, yfit);
    
    %{
    % if there are any infeasible ones, we need to impute data at those points
    % and then refit the model. That's how we handle infeasible points 
    if ~isempty(dataTable.Feasibility == -1)
        xfit_infeas = xfit_all(dataTable.Feasibility == -1, :);
        [mu_in, s2_in] = gp(hyp, inffunc1, meanfunc1, covfunc1, likfunc1, xfit, yfit, xfit_infeas, ones(length(xfit_infeas),1));
        
        %imput the data and refit
        xfit = [xfit;xfit_infeas];
        yfit = [yfit;mu_in+s2_in];% Based on forrester book (cite later you idiot) 
        
        hyp = minimize_noprint(hyp_init, @gp, -100, inffunc1, meanfunc1, covfunc1, likfunc1, xfit, yfit);
    end
    
    
    % Fit constraint model.
    hypcnst_init = struct('mean', 0, 'cov', [1;1;1]);
    g_feas = dataTable.Feasibility;
    hypcnst = minimize_noprint(hypcnst_init, @gp, -100, inffunc2, meanfunc2, covfunc1, likfunc2, xfit, g_feas);
    %}
    % need to double check that if everythings feasible it's all 1. It should
    % be
    
    % Do optimization, requires sampling the area and applying PF*EI
    xn = finding_design_space();
    %xn(:,1) = norm_design(xn(:,1),4,20);
    xn(:,1) = norm_design(xn(:,1),4,14);
    xn(:,2) = norm_design(xn(:,2),200,350);

    for i = 1:size(xfit, 1)
        % Find rows in xn that match the current row of xfit
        matches = ismember(xn, xfit(i, :), 'rows');
        % Remove matching rows from xn
        xn(matches, :) = [];
    end
    
    % using the latent model for probability of feasibility as the gmu and gs2
    % is via the actual model is designed for direct probability. We've had
    % more luck in the past and DETC2023-109993 (jetton et al.) showed little
    % to no difference.
    [fmu, fs2] = gp(hyp, inffunc1, meanfunc1, covfunc1, likfunc1, xfit, yfit, xn,ones(length(xn),1));
    %[gmu, gs2, gmu_latent, gs2_latent] = gp(hypcnst, inffunc2, meanfunc2, covfunc1, likfunc2, xfit, g_feas, xn,ones(length(xn),1));
    
    
    % Yes. This could be done better without the for loop. But it works
    min_feasible = min(yfit(dataTable.Feasibility==1));
    
    fs = sqrt(fs2);
    %gs_latent = sqrt(gs2_latent);
    %gmu_latent = -gmu_latent; %taking the negative so PF works since that's designs for negative == feasible
    
    % -- PF*EI search
    PFEI = zeros(length(xn),1);
    
    for i = 1:length(xn)
        if fs(i) > 0
            z = (min_feasible - fmu(i))/fs(i);
            EI = (min_feasible - fmu(i))*normcdf(z) + fs(i)*normpdf(z); %expected improvement
            POF = 1;% normcdf( - gmu_latent(i) /gs_latent(i));%probability of feasibility
            PFEI(i) = EI*POF; %multiplication for finding points of higher EI and POF
        else
            PFEI(i) = 0;
        end
    
    end
    
    [eipof_max, index] = max(PFEI);
    
    if eipof_max == 0
        % take mu response instead: PFEI believes it has converged
        % (borrowed from previous research for affecting convergence)
        [fmu_min, index] = min(fmu);    
    end

    x_next = xn(index,:);

    % find next design goal. Reverse the normalization so it's
    % understandable to the user
    marb_next = x_next(1);
    range_next = x_next(2);

    %marb_next = rev_norm(marb_next,4,20);
    marb_next = rev_norm(marb_next,4,14);
    range_next = rev_norm(range_next, 200, 350);


end
function auto_ks(data,printout)
    fprintf(printout)
    fprintf("\n\n")
    scaled_data = (data-mean(data))/std(data);
    [h, p] = kstest(scaled_data)
end
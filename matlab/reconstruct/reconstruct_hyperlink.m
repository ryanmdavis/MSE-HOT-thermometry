function fun_link_text = reconstruct_hyperlink(directory,scan_data,exp_num,exp_name)
switch scan_data.Method
    case 'rMD_HPCSI2 '
        if ~isempty(scan_data.Exp_type)
            switch scan_data.Exp_type
                case 'Dynamic_Spectroscopy '
                    fun_link_text_cell = strcat({'<a href="matlab: ['},exp_name,'_Sc',exp_num,',',exp_name,'_Sc',exp_num,'_freq] = reconstructBruker1DSeries(''',directory,'\',exp_num,{''');">Scan '},exp_num,{':</a>'},{'    '});
                    fun_link_text = fun_link_text_cell{1};
                otherwise
                    fun_link_text = [];
            end
        else
            fun_link_text = [];
        end
    case {'RARE ','rMD_HOT_RARE '}
        fun_link_text_cell = strcat({'<a href="matlab: ['},exp_name,'_Sc',exp_num,'_rare] = reconstructRAREMultiSlice3(''',directory,'\',exp_num,{''');">Scan '},exp_num,{':</a>'},{'    '});
        fun_link_text = fun_link_text_cell{1};
    case    'rMD_LactateEditingSlice_PRESS_CPMG '
        fun_link_text_cell = strcat({'<a href="matlab: ['},exp_name,'_Sc',exp_num,'_spects,',exp_name,'_Sc',exp_num,'_hz,',exp_name,'_Sc',exp_num,'_fids] = reconstructBruker1DseriesB(''',directory,'\',exp_num,{''');">Scan '},exp_num,{':</a>'},{'    '});
        fun_link_text = fun_link_text_cell{1};
    case {'PRESS ','rMD_PRESS_J_refocus '}
        fun_link_text_cell = strcat({'<a href="matlab: ['},exp_name,'_Sc',exp_num,'_spects] = reconstructBruker1Db(''',directory,'\',exp_num,{''');">Scan '},exp_num,{':</a>'},{'    '});
        fun_link_text = fun_link_text_cell{1};
    case 'rMD_CPMG '
        fun_link_text_cell = strcat({'<a href="matlab: ['},exp_name,'_Sc',exp_num,'_spects,',exp_name,'_Sc',exp_num,'_peak] = reconstructCPMG(''',directory,'\',exp_num,{''');">Scan '},exp_num,{':</a>'},{'    '});
        fun_link_text = fun_link_text_cell{1};       
    case 'rMD_HOT '
        p_meth = struct('Exp_type','n','RARE_mode',[]);
        p_meth = getPVEntry3([directory '\' num2str(exp_num) '\method'],p_meth);
        switch p_meth.Exp_type
            case 'HOT_2D '
%                 fun_link_text_cell = strcat({'<a href="matlab: ['},exp_name,'_Sc',exp_num,'_HOTspects,hz1_',exp_name,'_Sc',exp_num,',hz2_',exp_name,'_Sc',exp_num,'] = reconstructBruker2DHOTSpectra2Win(''',directory,'\',exp_num,{''');">Scan '},exp_num,{':</a>'},{'    '});
                %%%%reconstruct spectrum:%%%%%%%%%%%%
                %%%display2DSpectrumB(spectrum,f1_bw,f1_plot_center_fq,f1_plot_bw,f2_bw,f2_plot_center_fq,f2_plot_bw)
                [f1_bw,f1_plot_bw,f2_bw,f2_plot_bw] = getHotBWs(strcat(directory,num2str(exp_num),'\'),24000);
                start_to_exc = {'<a href="matlab: '};
                expressions_to_exc_1 = {strcat('[',exp_name,'_Sc',exp_num,'_HOTspects,hz1_',exp_name,'_Sc',exp_num,',hz2_',exp_name,'_Sc',exp_num,'] = reconstructBruker2DHOTSpectra2Win(''',directory,'\',exp_num,''');')};
                expressions_to_exc_2 = {strcat('displayHot2DSpectraB(',exp_name,'_Sc',exp_num,'_HOTspects,',num2str(f1_bw),',0,',num2str(f1_plot_bw),',',num2str(f2_bw),',0,',num2str(f2_plot_bw),');')};
                expressions_to_exc_3 = {strcat('set(gcf,''Name'',''',exp_name,'; Scan ',exp_num,''');')};
                end_to_exc = {strcat({'">Scan '},exp_num,{':</a>'},{'    '})};
                fun_link_text_cell_spect = strcat(start_to_exc,expressions_to_exc_1{1},expressions_to_exc_2{1},expressions_to_exc_3{1},end_to_exc{1});
                %%%%reconstruct fid:%%%%%%%%%%%%%%%%%
                start_to_exc_fid = {'<a href="matlab: '};
                expressions_to_exc_1_fid = {strcat('[',exp_name,'_Sc',exp_num,'_HOTfids,t1_',exp_name,'_Sc',exp_num,',t2_',exp_name,'_Sc',exp_num,'] = reconstructBruker2DHOTfids2Win(''',directory,'\',exp_num,''');')};
                expressions_to_exc_2_fid = {strcat('displayHot2Dfids(',exp_name,'_Sc',exp_num,'_HOTfids,t1_',exp_name,'_Sc',exp_num,',t2_',exp_name,'_Sc',exp_num,');')};
                expressions_to_exc_3_fid = {strcat('set(gcf,''Name'',''',exp_name,'; Scan ',exp_num,' fids '');')};
                end_to_exc_fid = {strcat({'">(fid)</a>'},{'    '})};
                fun_link_text_cell_fid = strcat(start_to_exc_fid,expressions_to_exc_1_fid{1},expressions_to_exc_2_fid{1},expressions_to_exc_3_fid{1},end_to_exc_fid{1});
                fun_link_text = strcat(fun_link_text_cell_spect{1},fun_link_text_cell_fid{1});
            case {'CRAZED_2D ','CRAZED '}
                [f1_bw,f1_plot_bw,f2_bw,f2_plot_bw] = getHotBWs(strcat(directory,num2str(exp_num),'\'),24000);
                start_to_exc = {'<a href="matlab: '};
                expressions_to_exc_1 = {strcat('[',exp_name,'_Sc',exp_num,'_CRAZEDspects,hz1_',exp_name,'_Sc',exp_num,',hz2_',exp_name,'_Sc',exp_num,'] = reconstructBruker2DSpectrum(''',directory,'\',exp_num,''');')};
                expressions_to_exc_2 = {'figure;'};
                expressions_to_exc_3 = {strcat('display2DSpectrumB(',exp_name,'_Sc',exp_num,'_CRAZEDspects,',num2str(f1_bw),',0,','4000',',',num2str(f2_bw),',0,','4000',');')};
%                 expressions_to_exc_3 = {strcat('display2DSpectrumB(',exp_name,'_Sc',exp_num,'_CRAZEDspects,',num2str(f1_bw),',0,',num2str(f1_plot_bw),',',num2str(f2_bw),',0,',num2str(f2_plot_bw),');')};
                end_to_exc = {strcat({'">Scan '},exp_num,{':</a>'},{'    '})};
                fun_link_text_cell = strcat(start_to_exc,expressions_to_exc_1{1},expressions_to_exc_2{1},expressions_to_exc_3{1},end_to_exc{1});
                fun_link_text = fun_link_text_cell{1};
            case 'HOT_2D_1win '
                start_to_exc = {'<a href="matlab: '};
                expressions_to_exc_1 = {strcat('[',exp_name,'_Sc',exp_num,'_HOTspects,',exp_name,'_Sc',exp_num,'_HOTfids,hz1_',exp_name,'_Sc',exp_num,',hz2_',exp_name,'_Sc',exp_num,'] = reconstructBruker2DHOTSpectra1Win(''',directory,'\',exp_num,''');')};
%                 expressions_to_exc_2 = {strcat('displayHot2DSpectra1win(',exp_name,'_Sc',exp_num,'_HOTspects,hz1_',exp_name,'_Sc',exp_num,',hz2_',exp_name,'_Sc',exp_num,');')};
%                 expressions_to_exc_3 = {strcat('set(gcf,''Name'',''',exp_name,'; Scan ',exp_num,''');')};
%                 expressions_to_exc_1_fid = {''};%{strcat('[',exp_name,'_Sc',exp_num,'_HOTfids,t1_',exp_name,'_Sc',exp_num,',t2_',exp_name,'_Sc',exp_num,'] = reconstructBruker2DHOTFids1Win(''',directory,'\',exp_num,''');')};
%                 expressions_to_exc_2_fid = {''};%{strcat('displayHot2Dfids1win(',exp_name,'_Sc',exp_num,'_HOTfids,t1_',exp_name,'_Sc',exp_num,',t2_',exp_name,'_Sc',exp_num,');')};
%                 expressions_to_exc_3_fid = {''};%{strcat('set(gcf,''Name'',''',exp_name,'; Scan ',exp_num,' fids '');')};
                end_to_exc = {strcat({'">Scan '},exp_num,{':</a>'},{'    '})};
                fun_link_text_cell = strcat(start_to_exc,expressions_to_exc_1{1},end_to_exc{1});

%                 fun_link_text_cell = strcat(start_to_exc,expressions_to_exc_1{1},expressions_to_exc_2{1},expressions_to_exc_3{1},expressions_to_exc_1_fid{1},expressions_to_exc_2_fid{1},expressions_to_exc_3_fid{1},end_to_exc{1});
                fun_link_text = fun_link_text_cell{1};
%                 start_to_exc = {'<a href="matlab: '};
%                 expressions_to_exc_1 = {strcat('[',exp_name,'_Sc',exp_num,'_HOT,',exp_name,'_Sc',exp_num,'_HOT_k,',exp_name,'_Sc',exp_num,'_HOT_t] = getDirScanInfo_HOTSLI_ZQSQ(''',directory,'\',exp_num,''');')};
%                 end_to_exc = {strcat({'">Scan '},exp_num,{':</a>'},{'    '})};
%                 fun_link_text_cell = strcat(start_to_exc,expressions_to_exc_1{1},end_to_exc{1});
%                 fun_link_text = fun_link_text_cell{1};
            case 'HOT_2D_SLI '
                start_to_exc = {'<a href="matlab: '};
                expressions_to_exc_1 = {strcat('[',exp_name,'_Sc',exp_num,'_HOT_SLI,',exp_name,'_Sc',exp_num,'_HOT_SLI_k] = getDirScanInfo_HOTSLI(''',directory,'\',exp_num,''');')};
                end_to_exc = {strcat({'">Scan '},exp_num,{':</a>'},{'    '})};
                fun_link_text_cell = strcat(start_to_exc,expressions_to_exc_1{1},end_to_exc{1});
                fun_link_text = fun_link_text_cell{1};
            case {'HOT_2D_SLI_ZQSQ ','HOT_2D_RARE_ZQSQ ','HOT_2D_1win_PRESS '}
                start_to_exc = {'<a href="matlab: '};
                expressions_to_exc_1 = {strcat('[',exp_name,'_Sc',exp_num,'_HOT_SLI,',exp_name,'_Sc',exp_num,'_HOT_SLI_k,',exp_name,'_Sc',exp_num,'_HOT_SLI_t,',exp_name,'_Sc',exp_num,'_HOT_SLI_nu] = getDirScanInfo_HOTSLI_ZQSQ(''',directory,'\',exp_num,''');')};
                end_to_exc = {strcat({'">Scan '},exp_num,{':</a>'},{'    '})};
                fun_link_text_cell = strcat(start_to_exc,expressions_to_exc_1{1},end_to_exc{1});
                fun_link_text = fun_link_text_cell{1};
            case 'HOT_2D_RARE_ZQSQ2 '
                switch p_meth.RARE_mode
                    case 'one_image '
                        start_to_exc_1 = {'<a href="matlab: '};
                        expressions_to_exc_1 = {strcat('[',exp_name,'_Sc',exp_num,'_HOT_RARE,',exp_name,'_Sc',exp_num,'_HOT_RARE_k,',exp_name,'_Sc',exp_num,'_HOT_RAREI_t] = getDirScanInfo_HOTSLI_ZQSQ2_spectra(''',directory,'\',exp_num,''');')};
                        end_to_exc_1 = {strcat({'">Scan '},exp_num,{' (Raw):</a>'},{'    '})};
                        start_to_exc_2 = {'<a href="matlab: '};
                        expressions_to_exc_2 = {strcat('[',exp_name,'_Sc',exp_num,'_HOT_RARE,',exp_name,'_Sc',exp_num,'_HOT_RARE_k,',exp_name,'_Sc',exp_num,'_HOT_RARE_t] = getDirScanInfo_HOTSLI_ZQSQ2_T(''',directory,'\',exp_num,''');')};
                        end_to_exc_2 = {strcat({'">Scan '},exp_num,{'(Temperature):</a>'},{'    '})};
                        fun_link_text_cell = strcat(start_to_exc_1,expressions_to_exc_1{1},end_to_exc_1{1},{'  '},start_to_exc_2,expressions_to_exc_2{1},end_to_exc_2{1});
                        fun_link_text = fun_link_text_cell{1};
                    case {'N_images ','none '}
                        start_to_exc_2 = {'<a href="matlab: '};
                        expressions_to_exc_2 = {strcat('[',exp_name,'_Sc',exp_num,'_HOT] = reconstruct_MSE_HOT(''',directory,'\',exp_num,''');')};
                        end_to_exc_2 = {strcat({'">Scan '},exp_num,{':</a>'},{'    '})};
                        fun_link_text_cell = strcat(start_to_exc_2,expressions_to_exc_2{1},end_to_exc_2{1});
                        fun_link_text = fun_link_text_cell{1};
                    otherwise
                        fun_link_text = [];
                end
            case {'HOT_2D_RARE_ZQSQ3 '}
                start_to_exc = {'<a href="matlab: '};
                expressions_to_exc_1 = {strcat('[',exp_name,'_Sc',exp_num,'_HOT_MSE_ZQSQ3] = getDirScanInfo_HOTMSE_ZQSQ3(''',directory,'\',exp_num,''');')};
                end_to_exc = {strcat({'">Scan '},exp_num,{':</a>'},{'    '})};
                fun_link_text_cell = strcat(start_to_exc,expressions_to_exc_1{1},end_to_exc{1});
                fun_link_text = fun_link_text_cell{1};
            otherwise
                fun_link_text=[];
        end
    case 'rMD_SliceProfile '
        fun_link_text_cell = strcat({'<a href="matlab: '},exp_name,'_Sc',exp_num,'_spects = reconstructAndDisplaySliceProfile(''',directory,'\',exp_num,{''');">Scan '},exp_num,{':</a>'},{'    '});
        fun_link_text = fun_link_text_cell{1};
    case 'rMD_PRESS_T2 '
%         fun_link_text_cell = strcat({'<a href="matlab: '},exp_name,'_Sc',exp_num,'_T2 = reconstructPRESST2(''',directory,'\',exp_num,{''');">Scan '},exp_num,{':</a>'},{'    '});
        fun_link_text_cell = strcat({'<a href="matlab: ['},exp_name,'_Sc',exp_num,'_T2] = reconstructPRESST2(''',exp_name,''',''',exp_num,{''');">Scan '},exp_num,{':</a>'},{'    '});
        fun_link_text = fun_link_text_cell{1};
        
    case 'rMD_PRESS_T1 '
        fun_link_text_cell = strcat({'<a href="matlab: ['},exp_name,'_Sc',exp_num,'_T1] = reconstructPRESST1(''',exp_name,''',''',exp_num,{''');">Scan '},exp_num,{':</a>'},{'    '});
        fun_link_text = fun_link_text_cell{1};
    case 'MGE '
        fun_link_text_cell = strcat({'<a href="matlab: ['},exp_name,'_Sc',exp_num,'_MGE] = reconMGE(''',directory,exp_num,{''');">Scan '},exp_num,{':</a>'},{'    '});
        fun_link_text = fun_link_text_cell{1};
    case 'rMD_MSME_WS '
        p_meth = struct('TE2DModeOnOff','Off','PVM_NEchoImages',1);
        p_meth = getPVEntry3([directory '\' num2str(exp_num) '\method'],p_meth);
        if strcmp(p_meth.TE2DModeOnOff,'On ')
            fun_link_text_cell = strcat({'<a href="matlab: ['},exp_name,'_Sc',exp_num,'_MSME,',exp_name,'_Sc',exp_num,'_T2,',exp_name,'_Sc',exp_num,'_T2_CI] = reconstructMSME2DT2(''',directory,exp_num,{''');">Scan '},exp_num,{':</a>'},{'    '});
            fun_link_text = fun_link_text_cell{1};
        elseif p_meth.PVM_NEchoImages > 1
            fun_link_text_cell = strcat({'<a href="matlab: ['},exp_name,'_Sc',exp_num,'_MSME,',exp_name,'_Sc',exp_num,'_T2,',exp_name,'_Sc',exp_num,'_T2_CI] = reconstructMSMET2(''',directory,exp_num,{''');">Scan '},exp_num,{':</a>'},{'    '});
            fun_link_text = fun_link_text_cell{1};
        else
            fun_link_text_cell = strcat({'<a href="matlab: ['},exp_name,'_Sc',exp_num,'_MSME] = reconstructBrukerSLI(''',directory,exp_num,{''');">Scan '},exp_num,{':</a>'},{'    '});
            fun_link_text = fun_link_text_cell{1};
        end
    case 'rMD_CRAZED2 '
        p_meth = struct('t1_inc',1);
        p_meth = getPVEntry3([directory '\' num2str(exp_num) '\method'],p_meth);
        if  p_meth.t1_inc == 1
            fun_link_text_cell = strcat({'<a href="matlab: ['},exp_name,'_Sc',exp_num,'_CRAZED,',exp_name,'_Sc',exp_num,'_k] = reconstructBrukerCRAZED(''',directory,exp_num,{''');">Scan '},exp_num,{':</a>'},{'    '});
            fun_link_text = fun_link_text_cell{1};
        else
            fun_link_text_cell = strcat({'<a href="matlab: ['},exp_name,'_Sc',exp_num,'_CRAZED,',exp_name,'_Sc',exp_num,'_k,',exp_name,'_Sc',exp_num,'_t2s,',exp_name,'_Sc',exp_num,'_t2s_ci] = reconstructBrukerCRAZEDT2star(''',directory,exp_num,{''');">Scan '},exp_num,{':</a>'},{'    '});
            fun_link_text = fun_link_text_cell{1};
        end
            
    otherwise
        fun_link_text_cell = {strcat({'Scan '},exp_num,{':'})};

end
fun_link_text_cell = adjustLinkSize(fun_link_text_cell,exp_num);
fun_link_text=fun_link_text_cell{1};

function fun_link_text_cell = adjustLinkSize(fun_link_text_cell,exp_num)

num_digits=floor(log10(str2double(exp_num)))+1;
total_white_spaces=4;
for ii=1:(total_white_spaces-num_digits)
    fun_link_text_cell{1}=strcat(fun_link_text_cell{1},{' '});
end



%this function reads f1 and f2 bandwidths from method file.  Also given a
%desired plotting bandwith, this function returns the actual plotting
%bandwidth based on the fact that plot_bw <= actual_bw
function [f1_bw,f1_plot_bw,f2_bw,f2_plot_bw] = getHotBWs(directory,plot_bw)

p_meth = struct('tau_min',[],'tau_max',[],'tau_inc',[],'PVM_SpecSWH',[],'PVM_SpecMatrix',[]);
p_meth = getPVEntry3(strcat(directory,'method'),p_meth);

f2_bw = p_meth.PVM_SpecSWH;
f1_acq_time = (p_meth.tau_max - p_meth.tau_min)/1000; %in seconds
f1_bw = p_meth.tau_inc/f1_acq_time;
if plot_bw > f1_bw
    f1_plot_bw = f1_bw;
else
    f1_plot_bw = plot_bw;
end

if plot_bw > f2_bw
    f2_plot_bw = p_meth.PVM_SpecSWH;
else
    f2_plot_bw = plot_bw;
end
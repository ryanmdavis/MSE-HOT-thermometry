% this function takes a stack of images where each voxel is the phase
% difference between iZQC and spin echo, and returns temperature maps
% inputs:
%   pd: 5D data of phase difference (repetition, evolution time, echo
%   number, phase, read)
%   directory: location of raw data
%   varargin: pass argumetn pair(...,'cal_curve',anonymous function) to use
%   a different temperature calibration than the default.
function varargout = imagesToTempNT_PD(pd,directory,varargin)

% optional input
invar = struct('cal_curve',[]);
argin = varargin;
invar = generateArgin(invar,argin);

% read image parameters
p_meth = struct('t1',[],'tau_max',[],'tau_inc',[],'tau_min',[]);
p_meth = getPVEntry3([directory '\method'],p_meth);
p_acqp = struct('ACQ_vd_list',[],'BF1',[]);
p_acqp = getPVEntry3([directory '\acqp'],p_acqp);
vd_list=parseVdList(p_acqp.ACQ_vd_list);

% define calibration curve.  Use default if not user specified
if isempty(invar.cal_curve)
    load(hotPath('calibration'),'T_of_nu');
    vtot = T_of_nu;
else
    vtot = invar.cal_curve;
end

% determine field strength and estimated iZQC frequency
fs=7*p_acqp.BF1/300.4; %300.4 MHz=7T
freq_est = 1.030*fs/7;

% the conversion from phase to frequency must be done once per sampled
% evolution time:
for vd_list_num=1:size(vd_list,2)
    time_evolution_ms=p_meth.t1+p_meth.tau_min+vd_list(vd_list_num)*1000;
    
    %determine what iZQC frequencies correspond to a phase wrap.  There would
    %never be less than 2 or more than 16 phase wraps for liquid water and
    %reasonable evolution times, hence the 2:10 range below
    nu_wrap=(2*(2:18)+1)/(2*time_evolution_ms/1000);
    
    %find the v_wrap just below the frequency estimate:
    nu_wrap_less_est=nu_wrap - freq_est*1000;
    nu_wrap_less_est(nu_wrap_less_est>0)=-inf;
    [~,nu_min_bin]=max(nu_wrap_less_est);
    nu_min=nu_wrap(nu_min_bin);
    
    %find the v_wrap just above the frequency estimate:
    nu_max=nu_wrap(nu_min_bin+1);
    
    %range of nu that can be detected without wrapping
    nu_range=nu_max-nu_min;

    nu_hot(:,vd_list_num,:,:,:)=nu_min+nu_range*(pd(:,vd_list_num,:,:,:)+pi)/(2*pi);

end

% convet to T using calibration curve vtot
t = vtot(nu_hot,fs);
varargout{1}=t;
if nargout ==2
    varargout{2}=nu_hot;
end
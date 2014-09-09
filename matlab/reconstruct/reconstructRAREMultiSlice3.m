% reconstructs a Bruker RARE experiment

function image = reconstructRAREMultiSlice3(raw_data_folder)
%This program uses the raw FID data, not the reco data. Use the 'fid' file not the 2dseq file.

%******************* Open and Read FID data ******************
fid1 = fopen([raw_data_folder '\fid'],'r','l');   %Open fid
fidmix1 = fread(fid1,inf,'int32');    %Read fid data as single line

%********************Gather RARE parameters*******************
p_acqp = struct('ACQ_size',[],'ACQ_rare_factor',[]);
p_acqp = getPVEntry3([raw_data_folder '\acqp'],p_acqp);
NpointPE = p_acqp.ACQ_size(1);
NpointRD = p_acqp.ACQ_size(2);
rare_factor = p_acqp.ACQ_rare_factor;


p_method = struct('PVM_EncSteps1',[],'PVM_SPackArrNSlices',[],'PVM_ObjOrderList',[],'PVM_SPackArrPhase1Offset',[],'PVM_Fov',[]);
p_method = getPVEntry3([raw_data_folder '\method'],p_method);
phase_steps = p_method.PVM_EncSteps1 - min(p_method.PVM_EncSteps1) + 1; %number the k space data in the PE direction from 1 to (Num PE steps)/2
num_slices = p_method.PVM_SPackArrNSlices;
slice_order = p_method.PVM_ObjOrderList;
%******************** Processing - Image 1 *******************************
fidcom = fidmix1(1:2:end) + 1i*fidmix1(2:2:end);
try
sorted_kspace_data = zeros(2,num_slices,NpointRD,NpointPE/2);
% sorted_kspace_data = zeros(num_slices,NpointRD,NpointPE/2);
for exitation_num = 1:NpointPE/(2*rare_factor);
    exitation_index = (exitation_num - 1) * num_slices * rare_factor * NpointRD * 2; %after each exitation, 2* rare_factor*NpointRD data are aquired.  This happens once per slice.
    for slice_num = 1:max(slice_order) + 1
        slice_index = (slice_num - 1) * rare_factor * NpointRD * 2;
        for rare_num = 1:rare_factor
            rare_index = (rare_num - 1) * NpointRD * 2;
            index = exitation_index + slice_index + rare_index;
            k_PE_location = phase_steps((exitation_num - 1) * rare_factor + rare_num);
%             sorted_kspace_data(slice_order(slice_num) + 1,ke_PE_location,:) = fidmix1(index+1:2:index+2*NpointRD-1);
            sorted_kspace_data(2,slice_order(slice_num) + 1,k_PE_location,:) = fidmix1(index+1:2:index+2*NpointRD-1);
            sorted_kspace_data(1,slice_order(slice_num) + 1,k_PE_location,:) = fidmix1(index+2:2:index+2*NpointRD);
        end
    end
end
catch
    keyboard;
end

clear fidmix1;
fidmix1 = sorted_kspace_data(1,:,:,:)+1i*sorted_kspace_data(2,:,:,:);  clear sorted_kspace_data           %Combine data from real and imaginary components
fidmix1 = reshape(fidmix1,size(fidmix1,2),size(fidmix1,3),size(fidmix1,4));

image_temp = zeros(num_slices,NpointRD, NpointPE/2);
for slice_num = 1:num_slices
    image_temp(slice_num,:,:) = abs(fftshift(fft2(fftshift(squeeze(fidmix1(slice_num,:,:))))));
end

shift_pe_voxels=round(size(image_temp,2)*p_method.PVM_SPackArrPhase1Offset/p_method.PVM_Fov(2));
image_temp=circshift(image_temp,[0 shift_pe_voxels 0]);

image = squeeze(image_temp);
bw=30080/3;
hz=linspace(-0.5*bw,0.5*bw,30080*8);

%% experimental 1H spectra of oleic_360MHz acid, palmitic acid, and cholesteryl benzoate at 360 MHz
% oleic_360MHz
oleic_360MHz=reconstructBruker1Dd('C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\Multi-echo HOT encoding\figures\simulations and CPMG\1H spectra at 360MHz\fid_oleic');
oleic_360MHz=circshift(phaseSpectrum(oleic_360MHz,0.2,0.001873),[0 -1147]); %0,0.001874
% figure,%subplot(1,2,1)
% plot(hz(124000:142000),real(oleic_360MHz(124000:142000)));
% subplot(1,2,2)
% plot(hz(131600:134800),real(oleic_360MHz(131600:134800)));

% palmitic
palmitic_360MHz=reconstructBruker1Dd('C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\Multi-echo HOT encoding\figures\simulations and CPMG\1H spectra at 360MHz\fid_palmitic');
palmitic_360MHz=phaseSpectrum(palmitic_360MHz,-0.7,0.00188);
% figure,subplot(1,2,1)
% plot(hz(124000:142000),real(palmitic_360MHz(124000:142000)));
% subplot(1,2,2)
% plot(hz(130600:132200),real(palmitic(130600:132200)));

% cholesteryl benzoate
cholesteryl_360MHz=reconstructBruker1Dd('C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\Multi-echo HOT encoding\figures\simulations and CPMG\1H spectra at 360MHz\fid_cholesteryl');
cholesteryl_360MHz=circshift(phaseSpectrum(cholesteryl_360MHz,-0.0,0.00188),[0 46036]);
% figure,%subplot(1,2,1)
% plot(real(cholesteryl_360MHz(124000:132000)));
% subplot(1,2,2)
% plot(real(cholesteryl_360MHz(83920:98100)));

solvent=183400:185100;
methyl=130200:133400;
% figure,subplot(1,2,1)
% plot(hz(solvent),real(oleic_360MHz(solvent)),'k');
% hold on
% plot(hz(solvent),real(palmitic_360MHz(solvent)),'b');
% % plot(hz(solvent),real(cholesteryl(solvent)),'r');
% xlim([2630 2645]);
% xlabel('resonance frequency (Hz)');
% hold on
% subplot(1,2,2)
% plot(hz(methyl),real(oleic_360MHz(methyl)),'k');
% hold on
% plot(hz(methyl),real(palmitic_360MHz(methyl)),'b');
% % plot(hz(methyl),real(cholesteryl(methyl)),'r');
% 
% legend('oleic_360MHz acid','palmitic acid');

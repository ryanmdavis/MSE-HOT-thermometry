function phased_acquisition = phaseSpectrum(raw_acquisition,zero_order,first_order)

% phase_correction = zero_order + first_order * (1:max(size(raw_acquisition)))/max(size(raw_acquisition));
phase_correction = zero_order + first_order * (1:max(size(raw_acquisition)))/1;

reall = real(raw_acquisition);
imagg = imag(raw_acquisition);

phased_acquisition_real = reall.*cos(phase_correction) - imagg.*sin(phase_correction);
phased_acquisition_imag = reall.*sin(phase_correction) + imagg.*cos(phase_correction);

phased_acquisition = phased_acquisition_real + i*phased_acquisition_imag;
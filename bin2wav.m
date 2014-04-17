function bin2wav(filename)

[y,fs,nbits]=binread([filename '.bin']);
audiowrite([filename '.wav'],y,fs,'BitsPerSample',nbits);
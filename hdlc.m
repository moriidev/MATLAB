clc;
clear ;
close all;

binstre='0111111011111001010111100010100101001110101001101000000111011001001011110110000111111001111110010010010100101000100101101010101010101010010101010100010100101010111111001111110111110010101111000101001010011101010010010100010101010111010101010101001111110011111100100100101001010011101110110011000011111100111111011111001010111100010100101001110101001001010001010101011101010101010100111111001111110010010010100101001110111011001100001111110011111101111100101011110001010010100111010100100101000101010101110101010101010011111100111111001001001010010100111011101100110000111111001111110111110010101111000101001010011101010010010100010101010111010101010101001111110011111100100100101001010011101110110011000011111100111111011111001010111100010100101001110101001001010001010101011101010101010100111111001111110010010010100101001110111011001100001111110';

pattern ='01111110';
indices = strfind(binstre, pattern);

num_frames = length(indices);
data={};
counter=1;
faildframe =[];

for i = 1:2:num_frames 
    frame = binstre(indices(i) + 8:indices(i + 1) - 1);
    count = 0;
    j = 1; 
    
    while j <= length(frame) 
        if frame(j) == '1' 
            count = count + 1; 
        else 
            if count == 5 
                frame(j) = [];
                j = j - 1;
            end
            count = 0; 
        end
        j = j + 1;
    end
     
    if strcmp(crc32(frame(1:end-32)),frame(end-31:end))
          data{counter}=frame(1:end-32);
       else 
          faildframe=[faildframe counter];
       end 
      counter=counter+1;
end


function crc = crc32(data) 

data=char(bin2dec(reshape(pad(data,ceil(length(data)/8)*8,'left','0'),8,[]).')).';
 % disp(char(bin2dec(reshape(pad(data,ceil(length(data)/8)*8,'right','0'),8,[]).')).');


polynomial = uint32(hex2dec('EDB88320'));
 
     crc = uint32(hex2dec('FFFFFFFF'));
 
     for i = 1:length(data)
         crc = bitxor(crc, uint32(data(i)));
         for j = 1:8
             if bitand(crc, 1)
                 crc = bitxor(bitshift(crc, -1), polynomial);
             else
                 crc = bitshift(crc, -1);
             end
         end
     end
 
     crc = bitcmp(crc);
crc=dec2bin(crc);

end

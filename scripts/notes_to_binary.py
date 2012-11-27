import os

note_to_binary = { 
  'REST': "0000", 
  'C':  "0001",
  'C#':  "0010",
  'D':  "0011",
  'D#':  "0100",
  'E':  "0101",
  'F':  "0110",
  'F#':  "0111",
  'G': "1000",
  'G#': "1001",
  'A': "1010",
  'A#': "1011",
  'B': "1100",
  'Ch': "1101"
}

for music_file in os.listdir('music'):
    song_output = []
    with open('music/%s' % music_file) as f:
        for line in f:
            if line.strip():
                (note, duration) = line.strip().split(' ')

                (numerator, denominator) = duration.split('/')
                time_duration = float(numerator) / float(denominator)

                song_output.extend([note_to_binary[note] for x in range(int(time_duration * 8.0))])

    f_w = open('binary_music/%s.coe' % music_file, 'w')
    f_w.write('memory_initialization_radix=2;\n')
    f_w.write('memory_initialization_vector=\n')
    f_w.write(',\n'.join(song_output[:-1]))
    f_w.write(',\n'+song_output[-1]+';')

    print 'Song: %s' % music_file
    print '\n'.join(song_output)

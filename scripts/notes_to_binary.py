import os

note_to_binary = { 
  'REST': "0000", 
  'C':  "0001",
  'D':  "0010",
  'E':  "0011",
  'F':  "0100",
  'G':  "0101",
  'A':  "0110",
  'B':  "0111",
  'Ch': "1000",
  'Dh': "1001",
  'Eh': "1010",
  'Fh': "1011",
  'Gh': "1100"
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

    f_w = open('binary_music/%s' % music_file, 'w')
    f_w.write(''.join(song_output))

    print 'Song: %s' % music_file
    print ''.join(song_output)

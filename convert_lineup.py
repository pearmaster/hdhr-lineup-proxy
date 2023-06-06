
import re
import sys
import json

if __name__ == '__main__':
    tuner_name = sys.argv[1]
    input_filename = sys.argv[2]
    output_filename = sys.argv[3]
    
    with open(input_filename, 'r') as fp:
        input_txt = fp.read()
    
    pattern = "SCANNING: ([0-9]+) \(us-bcast:([0-9]+)\)\nLOCK: 8vsb \(ss=[0-9]{1,3} snq=[0-9]{1,3} seq=[0-9]{1,3}\)\nTSID: 0x[0-9A-F]*\n((PROGRAM .*\n)+)"
    results = re.findall(pattern, input_txt, re.MULTILINE)
    
    lineup = list()
    for result in results:
        channel_pattern = "PROGRAM ([1-9]{1,2}): ([0-9]{1,2}\.[0-9]{1,2}) (.*)\n"
        channel_results = re.findall(channel_pattern, result[2])
        for ch in channel_results:
            entry = {
                "GuideNumber": str(ch[1]),
                "GuideName": str(ch[2]),
                "URL": f"hdhomerun://{tuner_name}/ch{result[0]}-{ch[0]}"
            }
            lineup.append(entry)
    
    with open(output_filename, 'w') as fp:
        json.dump(obj=lineup, fp=fp, indent=4)

    sys.exit(0)

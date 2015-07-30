import csv


def isfloat(value):
  try:
    float(value)
    return True
  except ValueError:
    return False

#infile = "/Users/felipegb94/sbel/build/Mesh2SPH_bin/test_pcd.pcd"
infile = "/Users/felipegb94/sbel/repos/PC_WebRender/meshes/cube.pcd"
outfile = "/Users/felipegb94/sbel/repos/PC_WebRender/meshes/cube.csv"



with open(infile) as fin, open(outfile, 'w') as fout:
    o=csv.writer(fout)
    for line in fin:
        line = line.split()
        if line[0] == 'FIELDS':
            newLine = line[1:]
            o.writerow(newLine)
        elif isfloat(line[0]):
            o.writerow(line)

        

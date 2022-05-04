f = open('n.txt','w')
i=1
while i<=32:
    f.write("    <comp lib=\"4\" loc=\"(260,")
    f.write(str(i*60))
    f.write(")\" name=\"Register\">\n")
    f.write("      <a name=\"width\" val=\"32\"/>\n")
    f.write("      <a name=\"label\" val=\"GR")
    f.write(str(i))
    f.write("\"/>\n")
    f.write("    </comp>\n")
    i+=1
    
f.close()

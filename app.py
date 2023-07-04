import yaml
VISUAL="⌘"
NAME="⌗"
ALTARNATE="⌂"
TAGS="⌬"
with open("uni.yaml",encoding="utf-8") as f:
    text = yaml.load(f,Loader=yaml.Loader)
    tags={}
    chars=text['chars']
    mapped={}
    names={}
    altgroups = {}
    for i in chars:
        char=chars[i]
        if char['symbol'] not in mapped:
            mapped[char['symbol']]=i
        else:
            if char['part']+'/'+char['symbol'] not in mapped:
                mapped[char['part']+'/'+char['symbol']]=i
            else:
                raise NameError("Cannot have two unicode symbol in the same group with the same abbr")
        for j in char['tags']:
            if j in tags:
                tags[j].append(i)
            else:
                tags[j]=[i]
        for j in char['name']:
            tries={0:[],1:[]}
            if j not in mapped:
                tries[0].append(j)
                names[j]=i
                names[char['part']+'/'+j]=i
            else:
                if char['part']+'/'+j not in names:
                    tries[1].append(j)
                    names[char['part']+'/'+j]=i
                else:
                    k=2
                    while True:
                        if char['part']+'/'+str(k)+j not in names:
                            try:
                                tries[k]
                            except:
                                tries[k]=[]
                            tries[k].append(char['part']+'/'+str(k)+j)
                            names[char['part']+'/'+str(k)+j]=i
                            break
            lit=[*tries.keys()]
            lit.sort()
            char['aName']=tries[lit[0]][0]
        if 'alts' in char:
            altgroups[char['aName']]=char['alts']
    with open("sup.ahk",'w',encoding='utf-8') as sup:
        sup.write("; Visual\n")
        for i in mapped:
            sup.write(f'Hotstring ":{chars[mapped[i]]["mode"]}:⌘{i}","{chr(mapped[i])}"\n')
        sup.write("; Tags(old: variants)\n")
        for i in tags:
            element = "["+",".join([f'"{chr(j)}"' for j in tags[i]])+"]" 
            sup.write(f'Hotstring ":?:⌬{i}",variant({element},1)\n')
        sup.write("; Identifires\n")
        for i in names:
            sup.write(f'Hotstring ":?c:⌗{i}","{chr(names[i])}"\n')

        sup.write('\n; Alts\n')
        for i in altgroups:
            element = "["+",".join([f'"{chr(j)}"' for j in altgroups[i]])+"]" 
            sup.write(f'Hotstring ":?:⌂{i}",variant({element},1)\n')
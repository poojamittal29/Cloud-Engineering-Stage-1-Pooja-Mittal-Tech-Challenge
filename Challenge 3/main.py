def getValue(object,key):
    key_arr = key.split("/")
    cur=object[key_arr[0]]
    for i in range (1,len(key_arr)):
        cur = cur[i]
    return cur

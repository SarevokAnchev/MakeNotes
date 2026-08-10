
BEGIN {}
{
    line = $3;
    match(line, /\[\[[ 0-9A-Za-z.\-]*\]\]/);
    while (RLENGTH > 0) {
        tag = substr(line, RSTART + 2, RLENGTH - 4);
        c[tag]++;
        line = substr(line, RSTART + RLENGTH);
        match(line, /\[\[[ 0-9A-Za-z.\-]*\]\]/);
    }
}
END {
    for (i in c) {
        print i" : "c[i]" reference(s)";
    }
}



BEGIN {}
{
    match($3, /\[\[[0-9A-Za-z.\-]*\]\]/);
    tag = substr($3, RSTART + 2, RLENGTH - 4);
    c[tag]++;
}
END {
    for (i in c) {
        print i" : "c[i]" reference(s)";
    }
}


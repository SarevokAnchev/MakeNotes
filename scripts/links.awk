
BEGIN {}
{
    path = $1;
    nline = $2;
    line = $3;
    sline = line
    split(path, file, ".md");
    gsub(/^[[:space:]]*/, "", line);
    match(sline, /\[\[[ 0-9A-Za-z.\-]*\]\]/);
    while (RLENGTH > 0) {
        tag = substr(sline, RSTART + 2, RLENGTH - 4);
        c[tag]=c[tag] \
            ? c[tag]"\n\n### "file[1]" :\ngoto : [link]("path":"nline")\n\n"line \
            : "\n\n### "file[1]" :\ngoto : [link]("path":"nline")\n\n"line;
        sline = substr(sline, RSTART + RLENGTH);
        match(sline, /\[\[[ 0-9A-Za-z.\-]*\]\]/);
    }
}
END {
    n = asorti(c, keys);
    for (i = 1; i <= n; i++) {
        print "\n\n## "keys[i]" :"c[keys[i]];
    }
}



BEGIN {}
{
    path = $1;
    nline = $2;
    line = $3;
    gsub(/^[[:space:]]*/, "", line);
    match(line, /D\[[0-9.\-]*\]/);
    date = substr(line, RSTART + 2, RLENGTH - 3);
    lines[date line] = line;
    paths[date line] = path":"nline;
}
END {
    n = asorti(lines, keys);
    for (i = 1; i <= n; i++) {
        print "\n\n"lines[keys[i]]"\n\ngoto : [link]("paths[keys[i]]")";
    }
}



BEGIN {}
{
    path = $1;
    nline = $2;
    line = $3;
    gsub(/^[[:space:]]*/, "", line);
    lines[path]=lines[path] ? lines[path]"\n\n"line : line;
}
END {
    n = asorti(lines, keys);
    for (i = 1; i <= n; i++) {
        split(keys[i], file, ".md");
        print "\n\n### "file[1]":\n\ngoto : [link](" keys[i] ")\n\n"lines[keys[i]];
    }
}


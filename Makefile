
editor = nvim
pagename = default

todo_proc = '{ split($$0, path, ":"); line = $$0; sub(path[1]":", "", line); gsub(/^[[:space:]]*/, "", line); lines[path[1]]=lines[path[1]] ? lines[path[1]]"\n\n"line : line } END { n = asorti(lines, keys); for (i = 1; i <= n; i++) { split(keys[i], file, ".md"); print "\n\n\#\#\# "file[1]":\n\ngoto : [link](" keys[i] ")\n\n"lines[keys[i]] } }'

links_proc = '{ split($$0, f, ":"); o = $$0; sub(f[1]":", "", o); split(f[1], p, ".md"); split(f[2], a, "\\[\\["); split(a[2], b, "\\]\\]"); c[b[1]]=c[b[1]] ? c[b[1]]"\n\n\#\#\# "p[1]" :\ngoto : [link]("f[1]")\n\n"f[2] : "\n\n\#\#\# "p[1]" :\ngoto : [link]("f[1]")\n\n"o } END { for (i in c) { print "\n\#\# "i" :"c[i] } }'

tags_proc = '{ split($$0, a, "\\[\\[");  split(a[2], b, "\\]\\]"); c[b[1]]++ } END { for (i in c) { print i" : "c[i]" reference(s)" } }'

deadlines_proc = '{ split($$0, path, ":"); line = $$0; sub(path[1]":", "", line); gsub(/^[[:space:]]*/, "", line); split(line, date, "D\\["); split(date[2], date, "\\]"); lines[date[1]line] = line; paths[date[1]line]=path[1] } END { n = asorti(lines, keys); for (i = 1; i <= n; i++) { print "\n\n"lines[keys[i]]"\n\ngoto : [link]("paths[keys[i]]")" } }'

all: links todo

links: links.md tags.md
todo: done.md todo_a.md todo_b.md todo_c.md deadlines.md

today:
	@mkdir -p journals
	@touch journals/$(shell date +'%Y_%m_%d').md
	@$(editor) journals/$(shell date +'%Y_%m_%d').md

page:
	@mkdir -p pages
	@touch pages/$(pagename).md
	@$(editor) pages/$(pagename).md

links.md: $(wildcard journals/*.md) $(wildcard pages/*.md)
	@printf "# Liens :" > links.md
	@grep -H '\[\[[0-9A-Za-z.\-]*\]\]' $^ | awk -F'\n' $(links_proc) >> links.md
	@printf "\n" >> links.md

tags.md: $(wildcard journals/*.md) $(wildcard pages/*.md)
	@grep -H '\[\[[0-9A-Za-z.\-]*\]\]' $^ | awk -F'\n' $(tags_proc) | sort > tags.md
	@printf "\n" >> tags.md

done.md: $(wildcard journals/*.md) $(wildcard pages/*.md)
	@printf "# Tâches finalisées :" > done.md
	@grep -H '\[x\]\|DONE' $^ | awk -F'\n' $(todo_proc) >> done.md
	@printf "\n" >> done.md

todo_a.md: $(wildcard journals/*.md) $(wildcard pages/*.md)
	@printf "# Tâches en cours :" > todo_a.md
	@printf "\n\n## Prioritaire :" >> todo_a.md
	@grep -H '\[ \]A\|TODO \[#A\]' $^ | awk -F'\n' $(todo_proc) >> todo_a.md
	@printf "\n" >> todo_a.md

todo_b.md: $(wildcard journals/*.md) $(wildcard pages/*.md)
	@printf "# Tâches en cours :" > todo_b.md
	@printf "\n\n## Secondaires :" >> todo_b.md
	@grep -H '\[ \]B\|TODO \[#B\]' $^ | awk -F'\n' $(todo_proc) >> todo_b.md
	@printf "\n" >> todo_b.md

todo_c.md: $(wildcard journals/*.md) $(wildcard pages/*.md)
	@printf "# Tâches en cours :" > todo_c.md
	@printf "\n\n## Tâches de fond :" >> todo_c.md
	@grep -H '\[ \][C ]\|TODO \[#C\]' $^ | awk -F'\n' $(todo_proc) >> todo_c.md
	@printf "\n" >> todo_c.md

deadlines.md: $(wildcard journals/*.md) $(wildcard pages/*.md)
	@printf "# Deadlines en cours :" > deadlines.md
	@grep -H '\[ \][A-C] D\[[0-9\-]\+\]' $^ | awk -F'\n' $(deadlines_proc) >> deadlines.md
	@printf "\n" >> deadlines.md


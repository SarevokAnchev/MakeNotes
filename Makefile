
editor = nvim
pagename = default

todo_proc = '{ split($$0, path, ":"); line = $$0; sub(path[1]":", "", line); gsub(/^[[:space:]]*/, "", line); lines[path[1]]=lines[path[1]] ? lines[path[1]]"\n\n"line : line } END { n = asorti(lines, keys); for (i = 1; i <= n; i++) { split(keys[i], file, ".md"); print "\n\n\#\#\# "file[1]":\n\ngoto : [link](" keys[i] ")\n\n"lines[keys[i]] } }'

links_proc = '{ split($$0, path, ":"); line = $$0; sub(path[1]":", "", line); split(path[1], file, ".md"); gsub(/^[[:space:]]*/, "", line); match(line, /\[\[[0-9A-Za-z.\-]*\]\]/); tag = substr(line, RSTART + 2, RLENGTH - 4); c[tag]=c[tag] ? c[tag]"\n\n\#\#\# "file[1]" :\ngoto : [link]("path[1]")\n\n"line : "\n\n\#\#\# "file[1]" :\ngoto : [link]("path[1]")\n\n"line } END { n = asorti(c, keys); for (i = 1; i <= n; i++) { print "\n\n\#\# "keys[i]" :"c[keys[i]] } }'

tags_proc = '{ match($$0, /\[\[[0-9A-Za-z.\-]*\]\]/); tag = substr($$0, RSTART + 2, RLENGTH - 4); c[tag]++ } END { for (i in c) { print i" : "c[i]" reference(s)" } }'

deadlines_proc = '{ split($$0, path, ":"); line = $$0; sub(path[1]":", "", line); gsub(/^[[:space:]]*/, "", line); split(line, date, "D\\["); split(date[2], date, "\\]"); lines[date[1]line] = line; paths[date[1]line]=path[1] } END { n = asorti(lines, keys); for (i = 1; i <= n; i++) { print "\n\n"lines[keys[i]]"\n\ngoto : [link]("paths[keys[i]]")" } }'

all: links todo

links: links.md tags.md
todo: done.md todo_a.md todo_b.md todo_c.md deadlines.md

today:
	@mkdir -p journals
	@if [ -f "journals/$(shell date +'%Y_%m_%d').md" ]; \
	then \
		touch journals/$(shell date +'%Y_%m_%d').md; \
	else \
		printf "# $(shell date +'%Y-%m-%d')" >> "journals/$(shell date +'%Y_%m_%d').md"; \
	fi
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


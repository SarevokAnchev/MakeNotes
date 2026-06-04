
editor = nvim
pagename = default

all: links todo

links: links.md tags.md
todo: todo.md todo_a.md todo_b.md todo_c.md

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
	@grep '\[\[[0-9A-Za-z.]*\]\]' $^ | awk -F'\n' '{ split($$0, f, ":"); o = $$0; sub(f[1]":", "", o); split(f[1], p, ".md"); split(f[2], a, "\\[\\["); split(a[2], b, "\\]\\]"); c[b[1]]=c[b[1]] ? c[b[1]]"\n\n### "p[1]" :\ngoto : [link]("f[1]")\n\n"f[2] : "\n\n### "p[1]" :\ngoto : [link]("f[1]")\n\n"o } END { for (i in c) { print "\n## "i" :"c[i] } }' >> links.md
	@printf "\n" >> links.md

tags.md: $(wildcard journals/*.md) $(wildcard pages/*.md)
	@grep '\[\[[0-9A-Za-z.]*\]\]' $^ | awk -F'\n' '{ split($$0, a, "\\[\\[");  split(a[2], b, "\\]\\]"); c[b[1]] } END { for (i in c) { print i } }' | sort > tags.md
	@printf "\n" >> tags.md

todo.md: $(wildcard journals/*.md) $(wildcard pages/*.md)
	@printf "# Tâches en cours :" > todo.md
	@printf "\n\n## Prioritaire :" >> todo.md
	@grep '\[ \]A\|TODO \[#A\]' $^ | awk -F'\n' '{ split($$0, a, ":"); o = $$0; sub(a[1]":", "", o); b[a[1]]=b[a[1]] ? b[a[1]]"\n\n"a[2] : a[2] } END { for (i in b) { split(i, f, ".md"); print "\n\n### "f[1]":\n\ngoto : [link](" i ")\n\n"b[i] } }' >> todo.md
	@printf "\n\n## Secondaire :" >> todo.md
	@grep '\[ \]B\|TODO \[#B\]' $^ | awk -F'\n' '{ split($$0, a, ":"); o = $$0; sub(a[1]":", "",o);  b[a[1]]=b[a[1]] ? b[a[1]]"\n\n"o : o } END { for (i in b) { split(i, f, ".md"); print "\n\n### "f[1]":\n\ngoto : [link](" i ")\n\n"b[i] } }' >> todo.md
	@printf "\n\n## Tâches de fond :" >> todo.md
	@grep '\[ \]C\|TODO \[#C\]' $^ | awk -F'\n' '{ split($$0, a, ":"); o = $$0; sub(a[1]":", "",o);  b[a[1]]=b[a[1]] ? b[a[1]]"\n\n"o : o } END { for (i in b) { split(i, f, ".md"); print "\n\n### "f[1]":\n\ngoto : [link](" i ")\n\n"b[i] } }' >> todo.md
	@printf "\n\n## Non classées :" >> todo.md
	@grep '\[ \] ' $^ | awk -F'\n' '{ split($$0, a, ":"); o = $$0; sub(a[1]":", "",o);  b[a[1]]=b[a[1]] ? b[a[1]]"\n\n"o : o } END { for (i in b) { split(i, f, ".md"); print "\n\n### "f[1]":\n\ngoto : [link](" i ")\n\n"b[i] } }' >> todo.md
	@printf "\n\n# Tâches finalisées :" >> todo.md
	@grep '\[x\]\|DONE' $^ | awk -F'\n' '{ split($$0, a, ":"); o = $$0; sub(a[1]":", "",o);  b[a[1]]=b[a[1]] ? b[a[1]]"\n\n"o : o } END { for (i in b) { split(i, f, ".md"); print "\n\n### "f[1]":\n\ngoto : [link](" i ")\n\n"b[i] } }' >> todo.md
	@printf "\n" >> todo.md

todo_a.md: $(wildcard journals/*.md) $(wildcard pages/*.md)
	@printf "# Tâches en cours :" > todo_a.md
	@printf "\n\n## Prioritaire :" >> todo_a.md
	@grep '\[ \]A\|TODO \[#A\]' $^ | awk -F'\n' '{ split($$0, a, ":"); o = $$0; sub(a[1]":", "",o);  b[a[1]]=b[a[1]] ? b[a[1]]"\n\n"o : o } END { for (i in b) { split(i, f, ".md"); print "\n\n### "f[1]":\n\ngoto : [link](" i ")\n\n"b[i] } }' >> todo_a.md
	@printf "\n\n# Tâches finalisées :" >> todo_a.md
	@grep '\[x\]A\|DONE \[#A\]' $^ | awk -F'\n' '{ split($$0, a, ":"); o = $$0; sub(a[1]":", "",o);  b[a[1]]=b[a[1]] ? b[a[1]]"\n\n"o : o } END { for (i in b) { split(i, f, ".md"); print "\n\n### "f[1]":\n\ngoto : [link](" i ")\n\n"b[i] } }' >> todo_a.md
	@printf "\n" >> todo_a.md

todo_b.md: $(wildcard journals/*.md) $(wildcard pages/*.md)
	@printf "# Tâches en cours :" > todo_b.md
	@printf "\n\n## Secondaires :" >> todo_b.md
	@grep '\[ \]B\|TODO \[#B\]' $^ | awk -F'\n' '{ split($$0, a, ":"); o = $$0; sub(a[1]":", "",o);  b[a[1]]=b[a[1]] ? b[a[1]]"\n\n"o : o } END { for (i in b) { split(i, f, ".md"); print "\n\n### "f[1]":\n\ngoto : [link](" i ")\n\n"b[i] } }' >> todo_b.md
	@printf "\n\n# Tâches finalisées :" >> todo_b.md
	@grep '\[x\]B\|DONE \[#B\]' $^ | awk -F'\n' '{ split($$0, a, ":"); o = $$0; sub(a[1]":", "",o);  b[a[1]]=b[a[1]] ? b[a[1]]"\n\n"o : o } END { for (i in b) { split(i, f, ".md"); print "\n\n### "f[1]":\n\ngoto : [link](" i ")\n\n"b[i] } }' >> todo_b.md
	@printf "\n" >> todo_b.md

todo_c.md: $(wildcard journals/*.md) $(wildcard pages/*.md)
	@printf "# Tâches en cours :" > todo_c.md
	@printf "\n\n## Tâches de fond :" >> todo_c.md
	@grep '\[ \]C\|TODO \[#C\]' $^ | awk -F'\n' '{ split($$0, a, ":"); o = $$0; sub(a[1]":", "",o);  b[a[1]]=b[a[1]] ? b[a[1]]"\n\n"o : o } END { for (i in b) { split(i, f, ".md"); print "\n\n### "f[1]":\n\ngoto : [link](" i ")\n\n"b[i] } }' >> todo_c.md
	@printf "\n\n# Tâches finalisées :" >> todo_c.md
	@grep '\[x\]C\|DONE \[#C\]' $^ | awk -F'\n' '{ split($$0, a, ":"); o = $$0; sub(a[1]":", "",o);  b[a[1]]=b[a[1]] ? b[a[1]]"\n\n"o : o } END { for (i in b) { split(i, f, ".md"); print "\n\n### "f[1]":\n\ngoto : [link](" i ")\n\n"b[i] } }' >> todo_c.md
	@printf "\n" >> todo_c.md


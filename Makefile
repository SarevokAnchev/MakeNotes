
editor = nvim
pagename = default

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
	@grep -nH '\[\[[0-9A-Za-z.\-]*\]\]' $^ | awk -F':' -f scripts/links.awk >> links.md
	@printf "\n" >> links.md

tags.md: $(wildcard journals/*.md) $(wildcard pages/*.md)
	@grep -nH '\[\[[0-9A-Za-z.\-]*\]\]' $^ | awk -F':' -f scripts/tags.awk | sort > tags.md
	@printf "\n" >> tags.md

done.md: $(wildcard journals/*.md) $(wildcard pages/*.md)
	@printf "# Tâches finalisées :" > done.md
	@grep -nH '\[x\]\|DONE' $^ | awk -F':' -f scripts/todo.awk >> done.md
	@printf "\n" >> done.md

todo_a.md: $(wildcard journals/*.md) $(wildcard pages/*.md)
	@printf "# Tâches en cours :" > todo_a.md
	@printf "\n\n## Prioritaire :" >> todo_a.md
	@grep -nH '\[ \]A\|TODO \[#A\]' $^ | awk -F':' -f scripts/todo.awk >> todo_a.md
	@printf "\n" >> todo_a.md

todo_b.md: $(wildcard journals/*.md) $(wildcard pages/*.md)
	@printf "# Tâches en cours :" > todo_b.md
	@printf "\n\n## Secondaires :" >> todo_b.md
	@grep -nH '\[ \]B\|TODO \[#B\]' $^ | awk -F':' -f scripts/todo.awk >> todo_b.md
	@printf "\n" >> todo_b.md

todo_c.md: $(wildcard journals/*.md) $(wildcard pages/*.md)
	@printf "# Tâches en cours :" > todo_c.md
	@printf "\n\n## Tâches de fond :" >> todo_c.md
	@grep -nH '\[ \][C ]\|TODO \[#C\]' $^ | awk -F':' -f scripts/todo.awk >> todo_c.md
	@printf "\n" >> todo_c.md

deadlines.md: $(wildcard journals/*.md) $(wildcard pages/*.md)
	@printf "# Deadlines en cours :" > deadlines.md
	@grep -nH '\[ \][A-C] D\[[0-9\-]\+\]' $^ | awk -F':' -f scripts/deadlines.awk >> deadlines.md
	@printf "\n" >> deadlines.md

clean:
	@rm -f links.md
	@rm -f deadlines.md
	@rm -f todo_a.md
	@rm -f todo_b.md
	@rm -f todo_c.md
	@rm -f done.md
	@rm -f tags.md


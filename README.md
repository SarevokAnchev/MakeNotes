
# MakeNotes : A simple notetaking system

## What is it ?

MakeNotes is a basic notetaking system base on a single `Makefile` with several `awk` scripts.

It is designed to allow a terminal-centered use, while being very minimal in its dependencies. All your notes are stored in markdown files, that are parsed to extract topic tags and todo marks.

## Usage

### Installation

To start taking your own notes, copy the `Makefile` and the `scripts` folder at the root of your new notes directory, then edit the Makefile to set your preferred editor command (default is `nvim`).

To create a new journal page at the date of today, you can use the command :

```bash
make today
```

### Create and link pages

To create a new topic page with a given name :

```bash
make page pagename=MyTopic
```

Inside your notes, you can create tags using the following syntax :

```

...

## Moons of Jupiter

[[Astronomy]] Section about the Moons of Jupiter

Blahblahblah...

```

Using the following command, you can then create files that gather tags from all your notes :

```bash
make
# OR
make links
```

This will create a `tags.md` file that contains :

```

...

Astronomy : 1 reference(s)

...

```

As well as a `links.md` file that contains :

```

...

### pages/jupiter :
goto : [link](pages/jupiter.md:23)

[[Astronomy]] Section about the Moons of Jupiter

...

```

### Use todo lists and deadlines

Inside your notes, you can also write todo tags this way :

```

[ ]A Very important thing to do

[ ]B Moderately important thing to do

[ ]C Less important thing to do

[x]A Very important task, that is already done

[ ]A D[2026-12-22] Very important thing to do, with a deadline

```

The following command prepares files that parse and gather these todo marks :

```bash
make
# OR
make todo
```

This will create the files `deadlines.md`, `todo_a.md`, `todo_b.md`... That contain all the todo marks of your note and links to the files in which they were found.

### Clean workspace

The following command cleans all the generated files :

```bash
make clean
```


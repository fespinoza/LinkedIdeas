# Linked Ideas

[![Code Climate](https://codeclimate.com/github/fespinoza/linked-ideas-osx/badges/gpa.svg)](https://codeclimate.com/github/fespinoza/linked-ideas-osx)

The application is to lay out some ideas in the computer, allowing you to
connect them, reorder them and classify them with color codes

On the other hand, the connexions between ideas can have text on its own as a
way to 'explain' the connexion of ideas.

## Feature Roadmap

- [x] adding/editing a concept [#4](https://github.com/fespinoza/linked-ideas-osx/pull/4)
- [x] read/write from files [#4](https://github.com/fespinoza/linked-ideas-osx/pull/4)
- [x] moving concepts [#4](https://github.com/fespinoza/linked-ideas-osx/pull/4)
- [x] selecting concepts [#4](https://github.com/fespinoza/linked-ideas-osx/pull/4)
- [x] adding links between concepts [#6](https://github.com/fespinoza/linked-ideas-osx/pull/6)
- [x] delete concepts/links [#9](https://github.com/fespinoza/linked-ideas-osx/pull/9)
- [x] improvements: resizable TextFields [#10](https://github.com/fespinoza/linked-ideas-osx/pull/10)
- [x] use formatted strings for concepts [#11](https://github.com/fespinoza/linked-ideas-osx/pull/11)
- [x] add color to links [#12](https://github.com/fespinoza/linked-ideas-osx/pull/12)
- [ ] undo/redo actions for concepts and links
- [ ] multiple select concepts (move them)
- [ ] align concepts
- [ ] add editable text to links
- [ ] add editable curvature to links
- [ ] zooming canvas
- [ ] panning canvas
- [ ] save canvas dimensions in document
- [ ] reorder concepts in canvas
- [ ] export document as image
- [ ] support for icloud documents

## A world of ideas

- add app indicator of not saved
- dismiss construction arrow on click
- construction line not on same worker
- BUG: LinkArrow when there is no intersection point with conceptViews
- BUG: dragging fails many times when concepts has already many links
- multi element dragging
- attributed strings on concepts
- control + dragging to create straight links
- aligment of concepts
- center text
- copy/paste/duplicate concepts/links
- improve who holds the reference to the data, canvas or document
- autosave document
- refactor conceptView/linkView use a delegate to decouple from Canvas
- fix link views to be outside canvas

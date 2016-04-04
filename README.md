# Linked Ideas

[![Code Climate](https://codeclimate.com/github/fespinoza/linked-ideas-osx/badges/gpa.svg)](https://codeclimate.com/github/fespinoza/linked-ideas-osx)

The application is to lay out some ideas in the computer, allowing you to
connect them, reorder them and classify them with color codes

On the other hand, the connexions between ideas can have text on its own as a
way to 'explain' the connexion of ideas.

## Feature Roadmap

- [x] adding/editing a concept
- [x] read/write from files
- [x] moving concepts
- [x] selecting concepts
- [x] adding links between concepts
- [ ] refactor: document ownership of data
- [ ] delete concepts/links
- [ ] undo/redo actions for concepts and links
- [ ] add editable text to links
- [ ] use formatted strings for concepts/links
- [ ] add editable curvature to links
- [ ] zooming canvas
- [ ] panning canvas
- [ ] save canvas dimensions in document
- [ ] export document as image
- [ ] autosave document
- [ ] support for timemachine
- [ ] support for icloud documents

## Feature Details

### Adding/Editing concepts

#### Cases

- [x] clicking the canvas adds a new concept, also:
  - [x] deselect all concepts
  - [x] disable the editing mode of all concepts
  - [x] remove any unsaved concept
- [x] entering text and pressing "enter" saves the concept **undoable**
- [x] concepts can be saved in files
- [x] concepts can be read from files
- [x] concepts can be (de)selected by single click on them
- [x] concepts can be edited by double clicking on them, and when this happens: **undoable**
  - [x] deselect all other concepts
  - [x] disable the editing mode of all other concepts
- [x] concepts can be moved by drag and drop them within the canvas **undoable**

#### A world of ideas

- add app indicator of not saved
- dismiss construction arrow on click
- no concept creation on link mode
- construction line not on same worker
- BUG: LinkArrow when there is no intersection point with conceptViews
- BUG: dragging fails many times when concepts has already many links
- document icon
- multi element dragging
- attributed strings on concepts
- control + dragging to create straight links
- aligment of concepts
- center text
- copy/paste/duplicate concepts/links
- moving/select mode
- fix size of text field when editing a concept
- improve who holds the reference to the data, canvas or document

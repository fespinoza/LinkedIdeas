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
- [ ] adding links between concepts
- [ ] delete concepts/links
- [ ] undo/redo actions for concepts and links
- [ ] add editable text to links
- [ ] add color to concepts/links
- [ ] add editable curvature to links
- [ ] zooming canvas
- [ ] panning canvas
- [ ] save canvas dimensions in document

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

#### Pending

- selecting a concept and then pressing "delete" key will remove that concept
  from the view and the file
- cancelling a concept creation by pressing "ESCAPE" key
- disable edit mode by pressing "ESCAPE" key
- support for multi-line concept creation with "SHIFT+ENTER"

#### Room for Improvement

- who holds the reference to the data, canvas or document
- sizing of ConceptView
- styling of ConceptView
